class DoctorProfile {
  const DoctorProfile({
    required this.name,
    required this.specialty,
    required this.email,
    required this.phone,
    required this.clinic,
    required this.clinicPhone,
    required this.address,
    required this.workingHours,
    required this.about,
  });

  final String name;
  final String specialty;
  final String email;
  final String phone;
  final String clinic;
  final String clinicPhone;
  final String address;
  final String workingHours;
  final String about;

  DoctorProfile copyWith({
    String? name,
    String? specialty,
    String? email,
    String? phone,
    String? clinic,
    String? clinicPhone,
    String? address,
    String? workingHours,
    String? about,
  }) => DoctorProfile(
    name: name ?? this.name,
    specialty: specialty ?? this.specialty,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    clinic: clinic ?? this.clinic,
    clinicPhone: clinicPhone ?? this.clinicPhone,
    address: address ?? this.address,
    workingHours: workingHours ?? this.workingHours,
    about: about ?? this.about,
  );
}

class DoctorProfileViewModel {
  DoctorProfileViewModel._();

  static DoctorProfile current = const DoctorProfile(
    name: 'د. أحمد محمد',
    specialty: 'أخصائي قلب وأوعية دموية',
    email: 'doctor@example.com',
    phone: '01012345678',
    clinic: 'عيادة صحتي',
    clinicPhone: '0223456789',
    address: 'القاهرة، مصر',
    workingHours: 'السبت إلى الخميس، 4 م - 9 م',
    about: 'طبيب متخصص في تقديم الرعاية الطبية ومتابعة المرضى.',
  );

  static void save(DoctorProfile profile) => current = profile;
}
