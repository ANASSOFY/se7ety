import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';
import 'package:se7ety/features/patient/doctors/viewmodel/doctors_by_specialty_view_model.dart';

class DoctorsBySpecialtyScreen extends StatelessWidget {
  final String specialty;

  const DoctorsBySpecialtyScreen({super.key, required this.specialty});

  List<Map<String, String>> get doctors =>
      DoctorsBySpecialtyViewModel(specialty).doctors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          specialty,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: doctors.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),

        itemBuilder: (context, index) {
          final doctor = doctors[index];

          return DoctorCard(
            name: doctor['name']!,
            specialty: doctor['specialty']!,
            rating: doctor['rating']!,
            imageSize: 65,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.doctorDetails,
              arguments: doctor,
            ),
          );
        },
      ),
    );
  }
}
