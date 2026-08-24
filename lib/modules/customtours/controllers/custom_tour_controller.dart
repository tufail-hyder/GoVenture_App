import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/custom_tour_model.dart';
import '../services/custom_tour_services.dart';

class CustomTourController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // ---- Where do you want to go? ----
  final locationCtrl = TextEditingController();
  final tourUrlCtrl = TextEditingController();

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

  // ---- Preferences ----
  final accommodationPrefCtrl = TextEditingController();
  final transportPrefCtrl = TextEditingController();
  final mealsPrefCtrl = TextEditingController();
  final activitiesPrefCtrl = TextEditingController();
  final guidePrefCtrl = TextEditingController();
  final specialRequirementsCtrl = TextEditingController();

  // ---- Budget ----
  final budgetCtrl = TextEditingController();
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

  // ---- Other details ----
  final otherDetailsCtrl = TextEditingController();

  final RxBool isSubmitting = false.obs;

  // ---- Error flags for the custom picker fields (Start/End Date, Nationality)
  // which aren't real TextFormFields, so Form.validate() can't catch them. ----
  final RxBool startDateError = false.obs;
  final RxBool endDateError = false.obs;
  final RxBool nationalityError = false.obs;

  Future<bool> submit() async {
    final formValid = formKey.currentState!.validate();

    startDateError.value = startDate.value == null;
    endDateError.value = endDate.value == null;
    nationalityError.value = nationality.value == null || nationality.value!.trim().isEmpty;

    if (!formValid || startDateError.value || endDateError.value || nationalityError.value) {
      return false;
    }

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