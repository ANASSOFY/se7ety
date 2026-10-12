class PatientAccountData {
  const PatientAccountData({
    required this.name,
    required this.email,
    required this.phone,
  });

  final String name;
  final String email;
  final String phone;
}

class PatientHealthData {
  const PatientHealthData({
    required this.age,
    required this.height,
    required this.weight,
    required this.chronicDiseaseAnswer,
    required this.chronicDiseases,
    required this.medicalHistory,
  });

  final String age;
  final String height;
  final String weight;
  final String chronicDiseaseAnswer;
  final String chronicDiseases;
  final String medicalHistory;
}
