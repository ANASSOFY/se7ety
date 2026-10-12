import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.appointment});
  final DoctorAppointment appointment;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 78),
          const SizedBox(height: 18),
          const Text('تم إرسال طلب الحجز', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text('${appointment.doctorName}\n${appointment.dateLabel} • ${appointment.time}\nالحالة: ${appointment.status}', textAlign: TextAlign.center, style: const TextStyle(height: 1.7, color: AppColors.textSecondary)),
          const SizedBox(height: 26),
          FilledButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.patientAppointments, (route) => route.settings.name == AppRoutes.patientHome), child: const Text('متابعة مواعيدي')),
          TextButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.patientHome, (route) => false), child: const Text('العودة للرئيسية')),
        ]),
      ))),
    ),
  );
}
