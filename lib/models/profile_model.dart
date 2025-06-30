class Profile {
  final String name;
  final String gender;
  final String birthPlace;
  final DateTime birthDate;
  final String phone;
  final String address;
  final String? occupation;
  final String? institution;

  Profile({
    required this.name,
    required this.gender,
    required this.birthPlace,
    required this.birthDate,
    required this.phone,
    required this.address,
    this.occupation,
    this.institution,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      gender: json['gender'],
      birthPlace: json['birth_place'],
      birthDate: DateTime.parse(json['birth_date']),
      phone: json['phone'],
      address: json['address'],
      occupation: json['occupation'],
      institution: json['institution'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender,
      'birth_place': birthPlace,
      'birth_date': birthDate.toIso8601String(),
      'phone': phone,
      'address': address,
      'occupation': occupation,
      'institution': institution,
    };
  }
}
