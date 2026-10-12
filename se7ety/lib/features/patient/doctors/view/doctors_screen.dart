import 'package:flutter/material.dart';

import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/widgets/section_title.dart';
import 'package:se7ety/features/patient/doctors/viewmodel/doctors_view_model.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SectionTitle('اختر التخصص'),

            const SizedBox(height: 8),

            Text(
              'اختر التخصص للعثور على الطبيب المناسب لك',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),

            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              itemCount: DoctorsViewModel.specialties.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),

              itemBuilder: (context, index) {
                final specialty = DoctorsViewModel.specialties[index];

                return _SpecialtyCard(
                  name: specialty['name']!,
                  icon: specialty['icon']!,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialtyCard extends StatelessWidget {
  final String name;
  final String icon;

  const _SpecialtyCard({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.doctorsBySpecialty,
            arguments: name,
          );
        },

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),

              const SizedBox(height: 12),

              Text(
                name,
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
