import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/empty_state_widget.dart';
import 'package:se7ety/core/widgets/async_list_state.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final _searchController = TextEditingController();
  int _tab = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final patients = DoctorPatientsViewModel.patients.where((patient) {
      final hasOpenAppointment = DoctorAppointmentsViewModel.appointments.any(
        (appointment) => appointment.patientName == patient.name &&
            const {'معلق', 'مؤكد'}.contains(appointment.status),
      );
      final isPrevious = patient.isPrevious && !hasOpenAppointment;
      final matchesTab = isPrevious == (_tab == 1);
      return matchesTab &&
          (query.isEmpty || patient.name.toLowerCase().contains(query));
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('المرضى'),
          automaticallyImplyLeading: widget.onOpenDrawer == null,
          leading: widget.onOpenDrawer == null
              ? null
              : IconButton(onPressed: widget.onOpenDrawer, icon: const Icon(Icons.menu)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'ابحث عن مريض بالاسم',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Column(children: [
      const Align(
                  alignment: Alignment.centerRight,
                  child: Text('الحالي: مسجل حديثًا أو لديه موعد قائم أو زيارة خلال آخر 12 شهرًا. السابق: آخر زيارة أقدم من سنة بلا موعد قائم.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 8),
                Row(
                children: [
                  _tabButton('الحاليون', 0),
                  const SizedBox(width: 10),
                  _tabButton('السابقون', 1),
                ],
              ),
              ]),
            ),
            Expanded(
              child: AsyncListState(
                isEmpty: patients.isEmpty,
                emptyState: const EmptyStateWidget(
                      title: 'لا يوجد مرضى',
                      message: 'جرّب البحث باسم مختلف.',
                    ),
                child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      itemCount: patients.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, index) => _patientTile(patients[index]),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final selected = _tab == index;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => _tab = index),
        style: OutlinedButton.styleFrom(
          foregroundColor: selected ? Colors.white : AppColors.textSecondary,
          backgroundColor: selected ? AppColors.primary : AppColors.surface,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _patientTile(DoctorPatient patient) => Card(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE4F4F1),
        child: Icon(Icons.person_outline, color: AppColors.primary),
      ),
      title: Text(
        patient.name,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text('${patient.age} • آخر زيارة: ${patient.lastVisit}'),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: AppColors.textSecondary,
      ),
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.doctorPatientDetails,
        arguments: patient,
      ),
    ),
  );
}
