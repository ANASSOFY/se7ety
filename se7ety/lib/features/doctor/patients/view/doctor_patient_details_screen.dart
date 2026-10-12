import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';

class DoctorPatientDetailsScreen extends StatelessWidget {
  const DoctorPatientDetailsScreen({super.key, required this.patient});

  final DoctorPatient patient;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('ملف المريض')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: Color(0xFFE4F4F1),
                  child: Icon(Icons.person, color: AppColors.primary, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient.age,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _detail(Icons.phone_outlined, 'رقم الهاتف', patient.phone),
          _detail(
            Icons.calendar_month_outlined,
            'آخر زيارة',
            patient.lastVisit,
          ),
          _detail(Icons.height_rounded, 'الطول', patient.height),
          _detail(Icons.monitor_weight_outlined, 'الوزن', patient.weight),
          _detail(Icons.medical_information_outlined, 'الأمراض المزمنة', patient.chronicDiseases),
          _detail(Icons.history, 'التاريخ المرضي', patient.medicalHistory),
          _detail(Icons.notes_outlined, 'ملاحظات الزيارة', patient.notes),
          if (patient.visits.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 10),
              child: Text('الزيارات السابقة', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
            for (final visit in patient.visits)
              _detail(Icons.event_note_outlined, 'زيارة', visit),
          ],
          const SizedBox(height: 10),
          if (patient.isPrevious)
            const Text(
              'مريض سابق',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
        ],
      ),
    ),
  );

  Widget _detail(IconData icon, String title, String value) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(value, textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ),
      ],
    ),
  );
}
