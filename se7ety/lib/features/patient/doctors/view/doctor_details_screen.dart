import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_assets.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/doctor/availability/doctor_availability.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String rating;

  const DoctorDetailsScreen({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'بيانات الدكتور',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 15),

            // Doctor Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),

              child: Image.asset(
                AppAssets.doctorCard,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            // Name
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            // Specialty
            Text(
              specialty,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
            ),

            const SizedBox(height: 12),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 22),

                const SizedBox(width: 5),

                Text(
                  rating,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // About
            _InfoCard(
              title: 'عن الدكتور',
              child: Text(
                DoctorProfileViewModel.current.about,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Working Hours
            _InfoCard(
              title: 'مواعيد العمل',
              child: Row(
                children: [
                  Icon(Icons.access_time_rounded, color: AppColors.primary),

                  const SizedBox(width: 10),

                  Text(
                    DoctorAvailabilityStore.current.summary,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Location
            _InfoCard(
              title: 'العنوان',
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, color: AppColors.primary),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      DoctorProfileViewModel.current.address,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
SizedBox(
  width: double.infinity,
  height: 55,
  child: ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, AppRoutes.bookAppointment, arguments: {
        'name': name,
        'specialty': specialty,
      });
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
    child: const Text(
      'احجز موعد',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),
            // Booking Button
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          child,
        ],
      ),
    );
  }
}
