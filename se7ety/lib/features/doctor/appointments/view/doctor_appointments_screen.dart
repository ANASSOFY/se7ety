import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/empty_state_widget.dart';
import 'package:se7ety/core/widgets/async_list_state.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key, this.onOpenDrawer});

  final VoidCallback? onOpenDrawer;

  @override
  State<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  late final List<DoctorAppointment> _appointments = List.of(
    DoctorAppointmentsViewModel.appointments,
  );
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final visible = _appointments
        .where(
          (item) => _tab == 0
          ? item.status != 'مكتمل' && item.status != 'مرفوض' && item.status != 'ملغي'
              : item.status == 'مكتمل',
        )
        .toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('المواعيد'),
          automaticallyImplyLeading: widget.onOpenDrawer == null,
          leading: widget.onOpenDrawer == null
              ? null
              : IconButton(onPressed: widget.onOpenDrawer, icon: const Icon(Icons.menu)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Row(
                children: [
                  _tabButton('القادمة', 0),
                  const SizedBox(width: 10),
                  _tabButton('المكتملة', 1),
                ],
              ),
            ),
            Expanded(
              child: AsyncListState(
                isEmpty: visible.isEmpty,
                emptyState: const EmptyStateWidget(
                  title: 'لا توجد مواعيد',
                  message: 'ستظهر المواعيد هنا عند توفرها.',
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) => _appointmentTile(visible[index]),
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
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _appointmentTile(DoctorAppointment appointment) {
    final statusColor = appointment.status == 'مؤكد' || appointment.status == 'مكتمل'
        ? AppColors.success
        : appointment.status == 'مرفوض' || appointment.status == 'ملغي'
        ? AppColors.error
        : AppColors.warning;
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE4F4F1),
          child: Icon(Icons.person_outline, color: AppColors.primary),
        ),
        title: Text(
          appointment.patientName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${appointment.dateLabel}  •  ${appointment.time}\n${appointment.reason}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Chip(label: Text(appointment.status), backgroundColor: statusColor.withValues(alpha: .12), labelStyle: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w700), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        ]),
        onTap: () async {
          final updated = await Navigator.pushNamed(
            context,
            AppRoutes.doctorAppointmentDetails,
            arguments: appointment,
          );
          if (updated is DoctorAppointment && mounted) {
            setState(() {
              final index = _appointments.indexWhere(
                (item) => item.id == updated.id,
              );
              final newlyCompleted = index >= 0 && _appointments[index].status != 'مكتمل';
              if (index >= 0) {
                _appointments[index] = updated;
                final sharedIndex = DoctorAppointmentsViewModel.appointments
                    .indexWhere((item) => item.id == updated.id);
                if (sharedIndex >= 0) {
                  DoctorAppointmentsViewModel.appointments[sharedIndex] = updated;
                }
                if (updated.status == 'مكتمل' && newlyCompleted) {
                  final patientIndex = DoctorPatientsViewModel.patients.indexWhere(
                    (patient) => patient.name == updated.patientName,
                  );
                  if (patientIndex >= 0) {
                    final patient = DoctorPatientsViewModel.patients[patientIndex];
                    final diagnosis = updated.diagnosis.isEmpty ? updated.reason : updated.diagnosis;
                    final visit = '${updated.dateLabel}: $diagnosis${updated.visitNotes.isEmpty ? '' : ' — ${updated.visitNotes}'}';
                    DoctorPatientsViewModel.patients[patientIndex] = patient.copyWith(
                      lastVisit: updated.date,
                      lastVisitAt: DateTime.now(),
                      visits: [...patient.visits, visit],
                    );
                  }
                }
              }
            });
          }
        },
      ),
    );
  }
}
