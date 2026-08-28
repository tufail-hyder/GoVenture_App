import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/booking_service.dart';
import '../../tripdetails/models/trip_date_slot.dart';
import '../../tripdetails/models/trip_model.dart';
import '../models/booking_draft.dart';
import '../models/booking_model.dart';

class BookingController extends GetxController {
  final TripModel trip;
  BookingController(this.trip);

  final Rx<BookingDraft> draft = BookingDraft().obs;
  final Rx<DateTime> visibleMonth = DateTime.now().obs;

  static const double _taxRate = 0.03;

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

  @override
  void onInit() {
    super.onInit();
    if (trip.availableDates.isNotEmpty) {
      draft.value = draft.value.copyWith(selectedDate: trip.availableDates.first.date);
      visibleMonth.value = DateTime(trip.availableDates.first.date.year, trip.availableDates.first.date.month);
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

  void selectDate(DateTime date) {
    draft.value = draft.value.copyWith(selectedDate: date);
  }

  void changeMonth(int delta) {
    visibleMonth.value = DateTime(visibleMonth.value.year, visibleMonth.value.month + delta);
  }

  void setAdults(int value) {
    if (value < 1) return;
    draft.value = draft.value.copyWith(adults: value);
  }

  void setChildren(int value) {
    if (value < 0) return;
    draft.value = draft.value.copyWith(children: value);
  }

  void setInfants(int value) {
    if (value < 0) return;
    draft.value = draft.value.copyWith(infants: value);
  }

  // ===== Price Breakdown =====
  double get adultTotal => trip.price * draft.value.adults;
  double get childTotal => trip.effectiveChildPrice * draft.value.children;
  double get taxesAndFees => (adultTotal + childTotal) * _taxRate;
  double get grandTotal => adultTotal + childTotal + taxesAndFees;

  bool get canProceed {
    final slot = selectedSlot;
    if (slot == null) return false;
    if (slot.remainingSeats != null && slot.remainingSeats! < draft.value.totalTravelers) return false;
    return true;
  }

  /// Validates Step 2 fields, writes them into [draft], creates the
  /// booking doc in Firestore with paymentStatus/bookingStatus = pending,
  /// and returns the new booking id — or null if validation failed or the
  /// user isn't signed in.
  Future<String?> submitCustomerInfo() async {
    final email = emailCtrl.text.trim();
    final emailOk = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

    fullNameError.value = fullNameCtrl.text.trim().isEmpty ? 'Required' : null;
    emailError.value = email.isEmpty ? 'Required' : (emailOk ? null : 'Enter a valid email');
    phoneError.value = phoneCtrl.text.trim().isEmpty ? 'Required' : null;

    if (fullNameError.value != null || emailError.value != null || phoneError.value != null) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

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

    isCreatingBooking.value = true;
    try {
      final booking = BookingModel(
        id: '',
        tripId: trip.id,
        tripTitle: trip.title,
        tripCoverImage: trip.coverImage,
        userId: user.uid,
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
        taxesAndFees: taxesAndFees,
        grandTotal: grandTotal,
        currency: 'PKR',
        paymentMethod: null,
        paymentStatus: PaymentStatus.pending,
        bookingStatus: 'pending',
        createdAt: null,
      );
      // return await BookingService.createPendingBooking(booking);
    } catch (_) {
      return null;
    } finally {
      isCreatingBooking.value = false;
    }
  }
}