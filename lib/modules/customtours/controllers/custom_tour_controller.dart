import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/custom_tour_model.dart';
import '../services/custom_tour_services.dart';

class CustomTourController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ---- Where do you want to go? ----
  final locationCtrl = TextEditingController();
  final tourUrlCtrl = TextEditingController();
  final RxnString locationError = RxnString();

  // ---- Arrangements (multi-select) ----
  static const List<String> arrangementOptions = [
    'Transportation',
    'Accommodation',
    'Meals',
    'Guide',
    'Letter of invitation (for visa)',
  ];
  final RxSet<String> selectedArrangements = <String>{}.obs;

  void toggleArrangement(String value) {
    selectedArrangements.contains(value)
        ? selectedArrangements.remove(value)
        : selectedArrangements.add(value);
  }

  // ---- Trip details ----
  final groupSizeCtrl = TextEditingController();
  final groupDetailsCtrl = TextEditingController();
  final daysCtrl = TextEditingController();
  final roomsCtrl = TextEditingController();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final startLocationCtrl = TextEditingController();
  final endLocationCtrl = TextEditingController();

  final RxnString groupSizeError = RxnString();
  final RxnString daysError = RxnString();
  final RxnString roomsError = RxnString();
  final RxnString startLocationError = RxnString();
  final RxnString endLocationError = RxnString();
  final RxBool startDateError = false.obs;
  final RxBool endDateError = false.obs;

  // ---- Preferences ----
  final accommodationPrefCtrl = TextEditingController();
  final transportPrefCtrl = TextEditingController();
  final mealsPrefCtrl = TextEditingController();
  final activitiesPrefCtrl = TextEditingController();
  final guidePrefCtrl = TextEditingController();
  final specialRequirementsCtrl = TextEditingController();

  // ---- Budget ----
  final budgetCtrl = TextEditingController();
  final RxnString budgetError = RxnString();
  static const List<Map<String, String>> currencies = [
    {'code': 'USD', 'label': 'USD - \$'},
    {'code': 'EUR', 'label': 'EUR - €'},
    {'code': 'GBP', 'label': 'GBP - £'},
    {'code': 'AUD', 'label': 'AUD - \$'},
    {'code': 'CAD', 'label': 'CAD - \$'},
    {'code': 'JPY', 'label': 'Yen - ¥'},
    {'code': 'PKR', 'label': 'PKR - Rs'},
  ];
  final RxString selectedCurrency = 'PKR'.obs;

  // ---- Contact details ----
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final RxnString nationality = RxnString();

  final RxnString firstNameError = RxnString();
  final RxnString lastNameError = RxnString();
  final RxnString emailError = RxnString();
  final RxnString phoneError = RxnString();
  final RxBool nationalityError = false.obs;

  // ---- Other details ----
  final otherDetailsCtrl = TextEditingController();

  final RxBool isSubmitting = false.obs;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void onInit() {
    super.onInit();

    // ---- Each listener clears its field's error the moment the value
    // becomes valid again, so the person doesn't have to re-tap Send
    // Request just to see the red state disappear. ----
    locationCtrl.addListener(() {
      if (locationError.value != null && locationCtrl.text.trim().isNotEmpty) {
        locationError.value = null;
      }
    });
    groupSizeCtrl.addListener(() {
      if (groupSizeError.value != null && groupSizeCtrl.text.trim().isNotEmpty) {
        groupSizeError.value = null;
      }
    });
    daysCtrl.addListener(() {
      if (daysError.value != null) {
        final t = daysCtrl.text.trim();
        if (t.isNotEmpty && int.tryParse(t) != null) daysError.value = null;
      }
    });
    roomsCtrl.addListener(() {
      if (roomsError.value != null) {
        final t = roomsCtrl.text.trim();
        if (t.isNotEmpty && int.tryParse(t) != null) roomsError.value = null;
      }
    });
    startLocationCtrl.addListener(() {
      if (startLocationError.value != null && startLocationCtrl.text.trim().isNotEmpty) {
        startLocationError.value = null;
      }
    });
    endLocationCtrl.addListener(() {
      if (endLocationError.value != null && endLocationCtrl.text.trim().isNotEmpty) {
        endLocationError.value = null;
      }
    });
    budgetCtrl.addListener(() {
      if (budgetError.value != null) {
        final t = budgetCtrl.text.trim();
        if (t.isNotEmpty && double.tryParse(t) != null) budgetError.value = null;
      }
    });
    firstNameCtrl.addListener(() {
      if (firstNameError.value != null && firstNameCtrl.text.trim().isNotEmpty) {
        firstNameError.value = null;
      }
    });
    lastNameCtrl.addListener(() {
      if (lastNameError.value != null && lastNameCtrl.text.trim().isNotEmpty) {
        lastNameError.value = null;
      }
    });
    emailCtrl.addListener(() {
      if (emailError.value != null) {
        final t = emailCtrl.text.trim();
        if (t.isNotEmpty && _emailPattern.hasMatch(t)) emailError.value = null;
      }
    });
    phoneCtrl.addListener(() {
      if (phoneError.value != null && phoneCtrl.text.trim().isNotEmpty) {
        phoneError.value = null;
      }
    });
  }

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      startDate.value = picked;
      startDateError.value = false;
      if (endDate.value != null && endDate.value!.isBefore(picked)) {
        endDate.value = null;
      }
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? (startDate.value ?? DateTime.now()),
      firstDate: startDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      endDate.value = picked;
      endDateError.value = false;
    }
  }

  /// Validates every required field directly (independent of Flutter's
  /// Form/TextFormField validator plumbing, which proved unreliable here)
  /// and returns true only if the whole form is valid. Each *Error field is
  /// read reactively by the matching input widget to show a red border and
  /// "Required" text — this is the single source of truth for validation.
  bool _validateAll() {
    String? req(String v) => v.trim().isEmpty ? 'Required' : null;

    locationError.value = req(locationCtrl.text);
    groupSizeError.value = req(groupSizeCtrl.text);
    startLocationError.value = req(startLocationCtrl.text);
    endLocationError.value = req(endLocationCtrl.text);
    firstNameError.value = req(firstNameCtrl.text);
    lastNameError.value = req(lastNameCtrl.text);
    phoneError.value = req(phoneCtrl.text);

    final daysText = daysCtrl.text.trim();
    daysError.value = daysText.isEmpty
        ? 'Required'
        : (int.tryParse(daysText) == null ? 'Enter a number' : null);

    final roomsText = roomsCtrl.text.trim();
    roomsError.value = roomsText.isEmpty
        ? 'Required'
        : (int.tryParse(roomsText) == null ? 'Enter a number' : null);

    final budgetText = budgetCtrl.text.trim();
    budgetError.value = budgetText.isEmpty
        ? 'Required'
        : (double.tryParse(budgetText) == null ? 'Enter a valid amount' : null);

    final emailText = emailCtrl.text.trim();
    emailError.value = emailText.isEmpty
        ? 'Required'
        : (!_emailPattern.hasMatch(emailText) ? 'Enter a valid email' : null);

    startDateError.value = startDate.value == null;
    endDateError.value = endDate.value == null;
    nationalityError.value = nationality.value == null || nationality.value!.trim().isEmpty;

    return locationError.value == null &&
        groupSizeError.value == null &&
        startLocationError.value == null &&
        endLocationError.value == null &&
        firstNameError.value == null &&
        lastNameError.value == null &&
        phoneError.value == null &&
        daysError.value == null &&
        roomsError.value == null &&
        budgetError.value == null &&
        emailError.value == null &&
        !startDateError.value &&
        !endDateError.value &&
        !nationalityError.value;
  }

  Future<bool> submit() async {
    if (!_validateAll()) return false;

    isSubmitting.value = true;
    try {
      final request = CustomTourRequestModel(
        location: locationCtrl.text.trim(),
        tourUrl: tourUrlCtrl.text.trim(),
        arrangements: selectedArrangements.toList(),
        groupSize: groupSizeCtrl.text.trim(),
        groupDetails: groupDetailsCtrl.text.trim(),
        numberOfDays: int.tryParse(daysCtrl.text.trim()),
        numberOfRooms: int.tryParse(roomsCtrl.text.trim()),
        startDate: startDate.value,
        endDate: endDate.value,
        startLocation: startLocationCtrl.text.trim(),
        endLocation: endLocationCtrl.text.trim(),
        accommodationPreference: accommodationPrefCtrl.text.trim(),
        transportPreference: transportPrefCtrl.text.trim(),
        mealsPreference: mealsPrefCtrl.text.trim(),
        activitiesPreference: activitiesPrefCtrl.text.trim(),
        guidePreference: guidePrefCtrl.text.trim(),
        specialRequirements: specialRequirementsCtrl.text.trim(),
        budgetPerPerson: double.tryParse(budgetCtrl.text.trim()),
        currency: selectedCurrency.value,
        firstName: firstNameCtrl.text.trim(),
        lastName: lastNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        nationality: nationality.value ?? '',
        otherDetails: otherDetailsCtrl.text.trim(),
      );
      await CustomTourRequestService.submitRequest(request);
      return true;
    } catch (_) {
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    locationCtrl.dispose();
    tourUrlCtrl.dispose();
    groupSizeCtrl.dispose();
    groupDetailsCtrl.dispose();
    daysCtrl.dispose();
    roomsCtrl.dispose();
    startLocationCtrl.dispose();
    endLocationCtrl.dispose();
    accommodationPrefCtrl.dispose();
    transportPrefCtrl.dispose();
    mealsPrefCtrl.dispose();
    activitiesPrefCtrl.dispose();
    guidePrefCtrl.dispose();
    specialRequirementsCtrl.dispose();
    budgetCtrl.dispose();
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    otherDetailsCtrl.dispose();
    super.onClose();
  }
}