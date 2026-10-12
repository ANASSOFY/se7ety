import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  DoctorProfile _profile = DoctorProfileViewModel.current;

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        automaticallyImplyLeading: widget.onOpenDrawer == null,
        leading: widget.onOpenDrawer == null
            ? null
            : IconButton(onPressed: widget.onOpenDrawer, icon: const Icon(Icons.menu)),
      ),
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
                  radius: 40,
                  backgroundColor: Color(0xFFE4F4F1),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: AppColors.primary,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _profile.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _profile.specialty,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _info(Icons.email_outlined, 'البريد الإلكتروني', _profile.email),
          _info(Icons.phone_outlined, 'رقم الهاتف', _profile.phone),
          _info(Icons.local_hospital_outlined, 'العيادة', _profile.clinic),
          _info(
            Icons.phone_in_talk_outlined,
            'هاتف العيادة',
            _profile.clinicPhone,
          ),
          _info(Icons.location_on_outlined, 'العنوان', _profile.address),
          _info(
            Icons.access_time_outlined,
            'مواعيد العمل',
            _profile.workingHours,
          ),
          _info(Icons.info_outline, 'نبذة', _profile.about),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('تعديل الملف الشخصي'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.welcome,
              (route) => false,
            ),
            icon: const Icon(Icons.logout),
            label: const Text('تسجيل الخروج'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _editProfile() async {
    final updated = await Navigator.pushNamed(
      context,
      AppRoutes.doctorProfileEdit,
      arguments: _profile,
    );
    if (updated is DoctorProfile && mounted) {
      DoctorProfileViewModel.save(updated);
      setState(() => _profile = updated);
    }
  }

  Widget _info(IconData icon, String label, String value) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
