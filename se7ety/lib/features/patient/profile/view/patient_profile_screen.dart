import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/patient/profile/viewmodel/patient_profile_view_model.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = PatientProfileViewModel.current;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFE4F4F1),
                  child: Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'معلوماتي',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _InfoTile(
            icon: Icons.phone_outlined,
            title: 'رقم الهاتف',
            value: profile.phone,
          ),
          _InfoTile(
            icon: Icons.cake_outlined,
            title: 'العمر',
            value: profile.age,
          ),
          _InfoTile(
            icon: Icons.height_rounded,
            title: 'الطول',
            value: profile.height,
          ),
          _InfoTile(
            icon: Icons.monitor_weight_outlined,
            title: 'الوزن',
            value: profile.weight,
          ),
          _InfoTile(
            icon: Icons.medical_information_outlined,
            title: 'الأمراض المزمنة',
            value:
                profile.chronicDiseaseAnswer == 'نعم' &&
                    profile.chronicDiseases.isNotEmpty
                ? profile.chronicDiseases
                : profile.chronicDiseaseAnswer,
          ),
          _InfoTile(
            icon: Icons.history,
            title: 'التاريخ المرضي والأدوية',
            value: profile.medicalHistory.isEmpty ? 'لا يوجد تاريخ مسجل' : profile.medicalHistory,
          ),
          const SizedBox(height: 20),
          Card(
            color: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
                color: AppColors.primary,
              ),
              title: const Text('حجوزاتي'),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.patientAppointments),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
