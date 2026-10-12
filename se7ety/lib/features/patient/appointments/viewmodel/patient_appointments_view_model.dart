import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';
import 'package:se7ety/features/patient/profile/viewmodel/patient_profile_view_model.dart';

class PatientAppointment {
  const PatientAppointment({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
    required this.isCompleted,
  });

  final String doctorName;
  final String specialty;
  final String date;
  final String time;
  final String status;
  final bool isCompleted;
}

class PatientAppointmentsViewModel {
  PatientAppointmentsViewModel._();

  static List<PatientAppointment> appointmentsFor(bool completed) {
    final patientName = PatientProfileViewModel.current.name;
    return DoctorAppointmentsViewModel.appointments
        .where((appointment) => appointment.patientName == patientName)
        .where((appointment) => completed
            ? const {'مكتمل', 'ملغي', 'مرفوض'}.contains(appointment.status)
            : const {'معلق', 'مؤكد'}.contains(appointment.status))
        .map((appointment) => PatientAppointment(
              doctorName: appointment.doctorName.isEmpty
                  ? DoctorProfileViewModel.current.name
                  : appointment.doctorName,
              specialty: appointment.specialty.isEmpty
                  ? DoctorProfileViewModel.current.specialty
                  : appointment.specialty,
              date: appointment.dateLabel,
              time: appointment.time,
              status: appointment.status,
              isCompleted: const {'مكتمل', 'ملغي', 'مرفوض'}.contains(appointment.status),
            ))
        .toList();
  }
}
