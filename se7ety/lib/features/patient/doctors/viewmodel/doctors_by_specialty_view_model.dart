class DoctorsBySpecialtyViewModel {
  const DoctorsBySpecialtyViewModel(this.specialty);

  final String specialty;

  List<Map<String, String>> get doctors => [
    {'name': 'علي محمد علي', 'specialty': specialty, 'rating': '5.0'},
    {'name': 'أحمد محمد', 'specialty': specialty, 'rating': '4.8'},
    {'name': 'سارة أحمد', 'specialty': specialty, 'rating': '4.7'},
    {'name': 'محمد محمود', 'specialty': specialty, 'rating': '4.6'},
  ];
}
