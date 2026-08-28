class BookingDraft {
  final DateTime? selectedDate;
  final int adults;
  final int children;
  final int infants;

  // ---- Step 2: Customer Information ----
  final String fullName;
  final String email;
  final String phone;
  final String specialRequests;
  final String emergencyContactName;
  final String emergencyContactPhone;

  BookingDraft({
    this.selectedDate,
    this.adults = 1,
    this.children = 0,
    this.infants = 0,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.specialRequests = '',
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
  });

  int get totalTravelers => adults + children + infants;

  BookingDraft copyWith({
    DateTime? selectedDate,
    int? adults,
    int? children,
    int? infants,
    String? fullName,
    String? email,
    String? phone,
    String? specialRequests,
    String? emergencyContactName,
    String? emergencyContactPhone,
  }) {
    return BookingDraft(
      selectedDate: selectedDate ?? this.selectedDate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      infants: infants ?? this.infants,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialRequests: specialRequests ?? this.specialRequests,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
    );
  }
}