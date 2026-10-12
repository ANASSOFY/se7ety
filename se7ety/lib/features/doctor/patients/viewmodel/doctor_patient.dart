class DoctorPatient {
  const DoctorPatient({
    required this.name,
    required this.age,
    required this.phone,
    required this.lastVisit,
    bool isPrevious = false,
    this.lastVisitAt,
    required this.notes,
    this.height = 'غير مسجل',
    this.weight = 'غير مسجل',
    this.chronicDiseases = 'غير مسجل',
    this.medicalHistory = 'لا يوجد تاريخ مرضي مسجل',
    this.visits = const [],
  }) : _wasPrevious = isPrevious;

  final String name;
  final String age;
  final String phone;
  final String lastVisit;
  final bool _wasPrevious;
  final DateTime? lastVisitAt;
  bool get isPrevious => lastVisitAt == null
      ? _wasPrevious
      : DateTime.now().difference(lastVisitAt!) > const Duration(days: 365);
  final String notes;
  final String height;
  final String weight;
  final String chronicDiseases;
  final String medicalHistory;
  final List<String> visits;

  DoctorPatient copyWith({String? lastVisit, DateTime? lastVisitAt, List<String>? visits}) => DoctorPatient(
    name: name, age: age, phone: phone,
    lastVisit: lastVisit ?? this.lastVisit,
    isPrevious: isPrevious,
    lastVisitAt: lastVisitAt ?? this.lastVisitAt,
    notes: notes, height: height, weight: weight,
    chronicDiseases: chronicDiseases, medicalHistory: medicalHistory,
    visits: visits ?? this.visits,
  );
}

class DoctorPatientsViewModel {
  DoctorPatientsViewModel._();

  static final patients = <DoctorPatient>[
    DoctorPatient(
      name: 'محمد أحمد',
      age: '32 سنة',
      phone: '01012345678',
      lastVisit: '1 أكتوبر 2026',
      isPrevious: false,
      lastVisitAt: DateTime(2026, 10, 1),
      notes: 'متابعة ضغط الدم',
      height: '175 سم',
      weight: '75 كجم',
      chronicDiseases: 'ضغط الدم',
      medicalHistory: 'متابعة ضغط الدم',
      visits: ['1 أكتوبر 2026: متابعة ضغط الدم'],
    ),
    DoctorPatient(
      name: 'سارة محمود',
      age: '26 سنة',
      phone: '01098765432',
      lastVisit: '8 أكتوبر 2026',
      isPrevious: false,
      lastVisitAt: DateTime(2026, 10, 8),
      notes: 'استشارة عامة',
      height: '162 سم',
      weight: '61 كجم',
      visits: ['8 أكتوبر 2026: استشارة عامة'],
    ),
    DoctorPatient(
      name: 'أحمد علي',
      age: '41 سنة',
      phone: '01112345678',
      lastVisit: '22 سبتمبر 2025',
      isPrevious: true,
      lastVisitAt: DateTime(2025, 9, 22),
      notes: 'متابعة دورية',
      visits: ['22 سبتمبر 2025: متابعة دورية'],
    ),
    DoctorPatient(
      name: 'منى خالد',
      age: '35 سنة',
      phone: '01222334455',
      lastVisit: '18 سبتمبر 2025',
      isPrevious: true,
      lastVisitAt: DateTime(2025, 9, 18),
      notes: 'مراجعة نتائج التحاليل',
      visits: ['18 سبتمبر 2025: مراجعة نتائج التحاليل'],
    ),
  ];
}
