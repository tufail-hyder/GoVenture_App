import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/booking_service.dart';
import '../../../services/review_service.dart';
import '../../tripdetails/models/trip_date_slot.dart';
import '../../tripdetails/models/trip_model.dart';
import '../models/booking_draft.dart';
import '../models/booking_model.dart';

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

PaymentStatus paymentStatusFromString(String value) {
  return PaymentStatus.values.firstWhere(
        (e) => e.name == value,
    orElse: () => PaymentStatus.pending,
  );
}

class BookingController extends GetxController {
  final TripModel trip;
  final DateTime? initialDate;
  BookingController(this.trip, {this.initialDate});

  final Rx<BookingDraft> draft = BookingDraft().obs;

  // ---- Header rating/reviews ----
  final RxDouble liveRating = 0.0.obs;
  final RxInt liveReviewCount = 0.obs;

  // ---- Step 2: Customer Information ----
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final specialRequestsCtrl = TextEditingController();
  final emergencyNameCtrl = TextEditingController();
  final emergencyPhoneCtrl = TextEditingController();

  final Rxn<String> fullNameError = Rxn<String>();
  final Rxn<String> emailError = Rxn<String>();
  final Rxn<String> phoneError = Rxn<String>();

  final RxBool isCreatingBooking = false.obs;
  final RxString createdBookingId = ''.obs;

  @override
  void onInit() {
    super.onInit();


    if (initialDate != null) {
      draft.value = draft.value.copyWith(selectedDate: initialDate);
    } else if (trip.availableDates.isNotEmpty) {
      draft.value = draft.value.copyWith(selectedDate: trip.availableDates.first.date);
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null) fullNameCtrl.text = user!.displayName!;
    if (user?.email != null) emailCtrl.text = user!.email!;

    fullNameCtrl.addListener(() {
      if (fullNameError.value != null && fullNameCtrl.text.trim().isNotEmpty) fullNameError.value = null;
    });
    emailCtrl.addListener(() {
      if (emailError.value != null && emailCtrl.text.trim().isNotEmpty) emailError.value = null;
    });
    phoneCtrl.addListener(() {
      if (phoneError.value != null && phoneCtrl.text.trim().isNotEmpty) phoneError.value = null;
    });

    _loadLiveRating();
  }

  Future<void> _loadLiveRating() async {
    try {
      final reviews = await ReviewService.getReviewsForTrip(trip.id);
      if (reviews.isEmpty) return;
      liveRating.value = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
      liveReviewCount.value = reviews.length;
    } catch (_) {

    }
  }
  // ---- Calendar month navigation ----
  final Rx<DateTime> visibleMonth = DateTime.now().obs;

  void changeMonth(int delta) {
    final next = DateTime(visibleMonth.value.year, visibleMonth.value.month + delta, 1);
    visibleMonth.value = next;
  }

  @override
  void onClose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    specialRequestsCtrl.dispose();
    emergencyNameCtrl.dispose();
    emergencyPhoneCtrl.dispose();
    super.onClose();
  }

  TripDateSlot? get selectedSlot {
    if (draft.value.selectedDate == null) return null;
    try {
      return trip.availableDates.firstWhere((s) =>
      s.date.year == draft.value.selectedDate!.year &&
          s.date.month == draft.value.selectedDate!.month &&
          s.date.day == draft.value.selectedDate!.day);
    } catch (_) {
      return null;
    }
  }

  void selectDate(DateTime date) => draft.value = draft.value.copyWith(selectedDate: date);
  void setAdults(int value) { if (value >= 1) draft.value = draft.value.copyWith(adults: value); }
  void setChildren(int value) { if (value >= 0) draft.value = draft.value.copyWith(children: value); }
  void setInfants(int value) { if (value >= 0) draft.value = draft.value.copyWith(infants: value); }


  double get adultTotal => trip.price * draft.value.adults;
  double get childTotal => trip.effectiveChildPrice * draft.value.children;
  double get grandTotal => adultTotal + childTotal;

  bool get canProceed {
    final slot = selectedSlot;
    if (slot == null) return false;
    if (slot.remainingSeats != null && slot.remainingSeats! < draft.value.totalTravelers) return false;
    return true;
  }

  Future<String?> submitCustomerInfo() async {
    final email = emailCtrl.text.trim();
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    fullNameError.value = fullNameCtrl.text.trim().isEmpty ? 'Required' : null;
    emailError.value = email.isEmpty ? 'Required' : (emailOk ? null : 'Enter a valid email');
    phoneError.value = phoneCtrl.text.trim().isEmpty ? 'Required' : null;

    if (fullNameError.value != null || emailError.value != null || phoneError.value != null) {
      return null;
    }

    draft.value = draft.value.copyWith(
      fullName: fullNameCtrl.text.trim(),
      email: email,
      phone: phoneCtrl.text.trim(),
      specialRequests: specialRequestsCtrl.text.trim(),
      emergencyContactName: emergencyNameCtrl.text.trim(),
      emergencyContactPhone: emergencyPhoneCtrl.text.trim(),
    );

    final d = draft.value;
    if (d.selectedDate == null) return null;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    isCreatingBooking.value = true;
    try {
      final booking = BookingModel(
        id: '',
        tripId: trip.id,
        tripTitle: trip.title,
        tripCoverImage: trip.coverImage,
        tripLocation: trip.location,
        tripDuration: trip.duration,
        itineraryPdfUrl: trip.itineraryPdfUrl,
        userId: uid,
        fullName: d.fullName,
        email: d.email,
        phone: d.phone,
        specialRequests: d.specialRequests,
        emergencyContactName: d.emergencyContactName,
        emergencyContactPhone: d.emergencyContactPhone,
        selectedDate: d.selectedDate!,
        adults: d.adults,
        children: d.children,
        infants: d.infants,
        adultTotal: adultTotal,
        childTotal: childTotal,
        grandTotal: grandTotal,
        currency: 'PKR',
        paymentMethod: null,
        paymentStatus: PaymentStatus.pending,
        bookingStatus: 'pending',
        createdAt: null,
      );

      final id = await BookingService.createPendingBooking(booking);
      createdBookingId.value = id;
      return id;
    } catch (_) {
      return null;
    } finally {
      isCreatingBooking.value = false;
    }
  }
}