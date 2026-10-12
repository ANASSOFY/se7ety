class PatientProfileData {
  const PatientProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.height,
    required this.weight,
    required this.chronicDiseaseAnswer,
    required this.chronicDiseases,
    this.medicalHistory = '',
  });

  final String name;
  final String email;
  final String phone;
  final String age;
  final String height;
  final String weight;
  final String chronicDiseaseAnswer;
  final String chronicDiseases;
  final String medicalHistory;
}

class PatientProfileViewModel {
  PatientProfileViewModel._();

  static PatientProfileData current = const PatientProfileData(
    name: 'محمد أحمد',
    email: 'mohamed@example.com',
    phone: '01012345678',
    age: '32 سنة',
    height: '175 سم',
    weight: '75 كجم',
    chronicDiseaseAnswer: 'نعم',
    chronicDiseases: 'ارتفاع ضغط الدم',
    medicalHistory: 'يتابع ضغط الدم بانتظام.',
  );

  static void save(PatientProfileData profile) => current = profile;
}
