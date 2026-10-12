class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';

  static const String patientLogin = '/patient/login';
  static const String patientRegister = '/patient/register';

  static const String doctorLogin = '/doctor/login';
  static const String doctorRegister = '/doctor/register';
  static const String forgotPassword = '/auth/forgot-password';

  static const String patientHome = '/patient/home';
  static const String patientSearch = '/patient/search';
  static const String doctorsList = '/patient/doctors';
  static const String doctorsBySpecialty = '/patient/doctors/specialty';
  static const String doctorDetails = '/patient/doctors/details';
  static const String bookAppointment = '/patient/book-appointment';
  static const String bookingConfirmation = '/patient/booking-confirmation';
  static const String patientAppointments = '/patient/appointments';
  static const String appointmentDetails = '/patient/appointments/details';
  static const String patientProfile = '/patient/profile';

  static const String doctorHome = '/doctor/home';
  static const String doctorAppointments = '/doctor/appointments';
  static const String doctorAppointmentDetails = '/doctor/appointments/details';
  static const String doctorPatients = '/doctor/patients';
  static const String doctorPatientDetails = '/doctor/patients/details';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorProfileEdit = '/doctor/profile/edit';
  static const String doctorNotifications = '/doctor/notifications';
}
