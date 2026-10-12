class DoctorAppointment {
  const DoctorAppointment({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.patientPhone,
    required this.date,
    required this.time,
    required this.reason,
    required this.status,
    this.doctorName = '',
    this.specialty = '',
    this.patientHeight = 'غير مسجل',
    this.patientWeight = 'غير مسجل',
    this.chronicDiseases = 'غير مسجل',
    this.medicalHistory = 'لا توجد تفاصيل مسجلة',
    this.diagnosis = '',
    this.visitNotes = '',
  });

  final String id;
  final String patientName;
  final String patientAge;
  final String patientPhone;
  final String date;
  final String time;
  final String reason;
  final String status;
  final String doctorName;
  final String specialty;
  final String patientHeight;
  final String patientWeight;
  final String chronicDiseases;
  final String medicalHistory;
  final String diagnosis;
  final String visitNotes;

  String get dateLabel {
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return date;
    const days = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return '${days[parsed.weekday - 1]} ${parsed.day}/${parsed.month}/${parsed.year}';
  }

  DoctorAppointment copyWith({String? status, String? diagnosis, String? visitNotes}) => DoctorAppointment(
    id: id,
    patientName: patientName,
    patientAge: patientAge,
    patientPhone: patientPhone,
    date: date,
    time: time,
    reason: reason,
    status: status ?? this.status,
    doctorName: doctorName,
    specialty: specialty,
    patientHeight: patientHeight,
    patientWeight: patientWeight,
    chronicDiseases: chronicDiseases,
    medicalHistory: medicalHistory,
    diagnosis: diagnosis ?? this.diagnosis,
    visitNotes: visitNotes ?? this.visitNotes,
  );
}

class DoctorAppointmentsViewModel {
  DoctorAppointmentsViewModel._();

  static final appointments = <DoctorAppointment>[
    DoctorAppointment(
      id: '1',
      patientName: 'محمد أحمد',
      patientAge: '32 سنة',
      patientPhone: '01012345678',
      date: '15 أكتوبر 2026',
      time: '05:30 مساءً',
      reason: 'متابعة دورية وفحص ضغط الدم',
      status: 'معلق',
      patientHeight: '175 سم',
      patientWeight: '75 كجم',
      chronicDiseases: 'ارتفاع ضغط الدم',
      medicalHistory: 'يتابع ضغط الدم بانتظام.',
    ),
    DoctorAppointment(
      id: '2',
      patientName: 'سارة محمود',
      patientAge: '26 سنة',
      patientPhone: '01098765432',
      date: '16 أكتوبر 2026',
      time: '06:00 مساءً',
      reason: 'استشارة طبية',
      status: 'مؤكد',
    ),
    DoctorAppointment(
      id: '3',
      patientName: 'أحمد علي',
      patientAge: '41 سنة',
      patientPhone: '01112345678',
      date: '22 سبتمبر 2025',
      time: '04:00 مساءً',
      reason: 'ألم متكرر في الصدر',
      status: 'مكتمل',
    ),
  ];
}
