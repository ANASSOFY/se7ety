import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/empty_state_widget.dart';
import 'package:se7ety/core/widgets/async_list_state.dart';
import 'package:se7ety/features/patient/appointments/viewmodel/patient_appointments_view_model.dart';
import 'package:se7ety/features/patient/appointments/widgets/appointment_card.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final appointments = PatientAppointmentsViewModel.appointmentsFor(
      _selectedTab == 1,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('حجوزاتي')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [_tabButton('القادمة', 0), _tabButton('السابقة', 1)],
              ),
            ),
          ),
          Expanded(
            child: AsyncListState(
              isEmpty: appointments.isEmpty,
              emptyState: const EmptyStateWidget(
                title: 'مفيش مواعيد هنا',
                message: 'مواعيدك هتظهر هنا لما تحجز موعد.',
              ),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: appointments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (_, index) =>
                    AppointmentCard(appointment: appointments[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
