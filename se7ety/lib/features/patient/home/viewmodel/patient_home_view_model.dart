class PatientHomeViewModel {
  PatientHomeViewModel._();

  static const List<String> titles = [
    'صُحَّتِي',
    'البحث عن طبيب',
    'الأطباء',
    'حسابي',
  ];

  static const List<Map<String, String>> specialties = [
    {'title': 'دكتور قلب'},
    {'title': 'جراحة عامة'},
    {'title': 'باطنة'},
    {'title': 'أطفال'},
    {'title': 'جلدية'},
  ];

  static const List<Map<String, String>> topRatedDoctors = [
    {'name': 'علي محمد علي', 'specialty': 'دكتور قلب', 'rating': '5'},
    {'name': 'فاروق جويده', 'specialty': 'جراحة عامة', 'rating': '5'},
    {'name': 'سارة أحمد', 'specialty': 'جلدية', 'rating': '4.8'},
  ];
}
