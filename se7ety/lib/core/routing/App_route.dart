import 'package:flutter/material.dart';
import 'package:se7ety/features/WelcomeScreen/view/WelcomeScreen.dart';
import 'package:se7ety/features/onboarding/view/OnboardingScreen.dart';
import 'package:se7ety/features/patient/appointments/view/patient_appointments_screen.dart';
import 'package:se7ety/features/patient/appointments/view/book_appointment_screen.dart';
import 'package:se7ety/features/patient/appointments/view/booking_confirmation_screen.dart';
import 'package:se7ety/features/patient/home/view/patient_home_screen.dart';
import 'package:se7ety/features/patient/search/view/search_screen.dart';
import 'package:se7ety/features/patient/doctors/view/doctors_screen.dart';
import 'package:se7ety/features/patient/doctors/view/doctors_by_specialty_screen.dart';
import 'package:se7ety/features/patient/doctors/view/doctor_details_screen.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/features/splash/view/SplashScreen.dart';
import 'package:se7ety/features/auth/patient/login/view/patient_login_screen.dart';
import 'package:se7ety/features/auth/patient/register/view/patient_register_screen.dart';
import 'package:se7ety/features/auth/doctor/login/view/doctor_login_screen.dart';
import 'package:se7ety/features/auth/doctor/register/view/doctor_register_screen.dart';
import 'package:se7ety/features/doctor/home/view/doctor_home_screen.dart';
import 'package:se7ety/features/doctor/appointments/view/doctor_appointments_screen.dart';
import 'package:se7ety/features/doctor/appointments/view/doctor_appointment_details_screen.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';
import 'package:se7ety/features/doctor/patients/view/doctor_patients_screen.dart';
import 'package:se7ety/features/doctor/patients/view/doctor_patient_details_screen.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';
import 'package:se7ety/features/doctor/profile/view/doctor_profile_screen.dart';
import 'package:se7ety/features/doctor/profile/view/edit_doctor_profile_screen.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';
import 'package:se7ety/features/doctor/notifications/view/doctor_notifications_screen.dart';
import 'package:se7ety/features/auth/forgot_password/view/forgot_password_screen.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());

      case AppRoutes.patientLogin:
        return MaterialPageRoute(builder: (_) => const PatientLoginScreen());

      case AppRoutes.patientRegister:
        return MaterialPageRoute(builder: (_) => const PatientRegisterScreen());

      case AppRoutes.doctorLogin:
        return MaterialPageRoute(builder: (_) => const DoctorLoginScreen());

      case AppRoutes.doctorRegister:
        return MaterialPageRoute(builder: (_) => const DoctorRegisterScreen());

      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());

      case AppRoutes.bookAppointment:
        final arguments = settings.arguments as Map<String, String>? ?? {};
        return MaterialPageRoute(builder: (_) => BookAppointmentScreen(
          doctorName: arguments['name'] ?? DoctorProfileViewModel.current.name,
          specialty: arguments['specialty'] ?? DoctorProfileViewModel.current.specialty,
        ));

      case AppRoutes.bookingConfirmation:
        final appointment = settings.arguments is DoctorAppointment
            ? settings.arguments! as DoctorAppointment
            : DoctorAppointmentsViewModel.appointments.last;
        return MaterialPageRoute(builder: (_) => BookingConfirmationScreen(appointment: appointment));

      case AppRoutes.doctorHome:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case AppRoutes.doctorAppointments:
        return MaterialPageRoute(
          builder: (_) => const DoctorAppointmentsScreen(),
        );

      case AppRoutes.doctorAppointmentDetails:
        final appointment = settings.arguments is DoctorAppointment
            ? settings.arguments! as DoctorAppointment
            : DoctorAppointmentsViewModel.appointments.first;
        return MaterialPageRoute(
          builder: (_) =>
              DoctorAppointmentDetailsScreen(appointment: appointment),
        );

      case AppRoutes.doctorPatients:
        return MaterialPageRoute(builder: (_) => const DoctorPatientsScreen());

      case AppRoutes.doctorPatientDetails:
        final patient = settings.arguments is DoctorPatient
            ? settings.arguments! as DoctorPatient
            : DoctorPatientsViewModel.patients.first;
        return MaterialPageRoute(
          builder: (_) => DoctorPatientDetailsScreen(patient: patient),
        );

      case AppRoutes.doctorProfile:
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());

      case AppRoutes.doctorProfileEdit:
        final profile = settings.arguments is DoctorProfile
            ? settings.arguments! as DoctorProfile
            : DoctorProfileViewModel.current;
        return MaterialPageRoute(
          builder: (_) => EditDoctorProfileScreen(profile: profile),
        );

      case AppRoutes.doctorNotifications:
        return MaterialPageRoute(
          builder: (_) => const DoctorNotificationsScreen(),
        );

      case AppRoutes.patientHome:
        return MaterialPageRoute(builder: (_) => const PatientHomeScreen());

      case AppRoutes.patientSearch:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(
            initialQuery: settings.arguments is String
                ? settings.arguments! as String
                : '',
          ),
        );

      case AppRoutes.doctorsList:
        return MaterialPageRoute(builder: (_) => const DoctorsScreen());

      case AppRoutes.doctorsBySpecialty:
        return MaterialPageRoute(
          builder: (_) => DoctorsBySpecialtyScreen(
            specialty: settings.arguments is String
                ? settings.arguments! as String
                : '',
          ),
        );

      case AppRoutes.doctorDetails:
        final arguments = settings.arguments as Map<String, String>? ?? {};

        return MaterialPageRoute(
          builder: (_) => DoctorDetailsScreen(
            name: arguments['name'] ?? '',
            specialty: arguments['specialty'] ?? '',
            rating: arguments['rating'] ?? '',
          ),
        );

      case AppRoutes.patientAppointments:
        return MaterialPageRoute(
          builder: (_) => const PatientAppointmentsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('الصفحة "${settings.name}" مش موجودة')),
          ),
        );
    }
  }
}
