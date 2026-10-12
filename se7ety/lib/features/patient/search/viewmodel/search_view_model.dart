class SearchDoctor {
  const SearchDoctor({
    required this.name,
    required this.specialty,
    required this.rating,
  });

  final String name;
  final String specialty;
  final String rating;
}

class SearchViewModel {
  SearchViewModel({String initialQuery = ''}) : query = initialQuery;

  String query;

  static const List<SearchDoctor> doctors = [
    SearchDoctor(name: 'علي محمد علي', specialty: 'دكتور قلب', rating: '5.0'),
    SearchDoctor(name: 'فاروق جويده', specialty: 'جراحة عامة', rating: '5.0'),
    SearchDoctor(name: 'سارة أحمد', specialty: 'جلدية', rating: '4.8'),
  ];

  List<SearchDoctor> get results {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return doctors;

    return doctors.where((doctor) {
      return doctor.name.toLowerCase().contains(normalizedQuery) ||
          doctor.specialty.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  void updateQuery(String value) => query = value;
}
