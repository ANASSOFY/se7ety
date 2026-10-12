import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/primary_button.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  const DoctorAppointmentDetailsScreen({super.key, required this.appointment});
  final DoctorAppointment appointment;

  @override
  State<DoctorAppointmentDetailsScreen> createState() => _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState extends State<DoctorAppointmentDetailsScreen> {
  late final _diagnosis = TextEditingController(text: widget.appointment.diagnosis);
  late final _notes = TextEditingController(text: widget.appointment.visitNotes);

  @override
  void dispose() { _diagnosis.dispose(); _notes.dispose(); super.dispose(); }

  void _returnWith(String status) => Navigator.pop(
    context,
    widget.appointment.copyWith(status: status, diagnosis: _diagnosis.text.trim(), visitNotes: _notes.text.trim()),
  );

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    final pending = appointment.status == 'معلق';
    final confirmed = appointment.status == 'مؤكد';
    final color = appointment.status == 'مؤكد' ? AppColors.success : appointment.status == 'معلق' ? AppColors.warning : AppColors.textSecondary;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('تفاصيل الموعد')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          _card('بيانات المريض', [
            _row(Icons.person_outline, 'الاسم', appointment.patientName),
            _row(Icons.cake_outlined, 'العمر', appointment.patientAge),
            _row(Icons.phone_outlined, 'الهاتف', appointment.patientPhone),
            _row(Icons.height, 'الطول', appointment.patientHeight),
            _row(Icons.monitor_weight_outlined, 'الوزن', appointment.patientWeight),
            _row(Icons.medical_information_outlined, 'الأمراض المزمنة', appointment.chronicDiseases),
            _row(Icons.history, 'التاريخ المرضي', appointment.medicalHistory),
          ]),
          const SizedBox(height: 14),
          _card('بيانات الموعد', [
            _row(Icons.calendar_today_outlined, 'التاريخ', appointment.dateLabel),
            _row(Icons.access_time_outlined, 'الوقت', appointment.time),
            Row(children: [const Icon(Icons.info_outline, size: 18, color: AppColors.primary), const SizedBox(width: 9), const Text('الحالة: '), Chip(label: Text(appointment.status), backgroundColor: color.withValues(alpha: .12), labelStyle: TextStyle(color: color, fontWeight: FontWeight.w700), visualDensity: VisualDensity.compact)]),
            _row(Icons.notes_outlined, 'سبب الزيارة', appointment.reason),
          ]),
          if (confirmed || appointment.status == 'مكتمل') ...[
            const SizedBox(height: 14),
            _card('ملاحظات الزيارة', [
              TextField(controller: _diagnosis, maxLines: 2, decoration: const InputDecoration(labelText: 'التشخيص', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _notes, maxLines: 3, decoration: const InputDecoration(labelText: 'ملاحظات الدكتور', border: OutlineInputBorder())),
            ]),
          ],
          if (pending) ...[
            const SizedBox(height: 24),
            PrimaryButton(label: 'قبول الموعد', icon: Icons.check_rounded, onPressed: () => _returnWith('مؤكد')),
            const SizedBox(height: 12),
            OutlinedButton.icon(onPressed: () => _returnWith('مرفوض'), icon: const Icon(Icons.close_rounded), label: const Text('رفض الموعد'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, padding: const EdgeInsets.symmetric(vertical: 14))),
          ] else if (confirmed) ...[
            const SizedBox(height: 22),
            PrimaryButton(label: 'حفظ التشخيص وإكمال الموعد', icon: Icons.task_alt, onPressed: () => _returnWith('مكتمل')),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: () => _returnWith('ملغي'), icon: const Icon(Icons.event_busy), label: const Text('إلغاء الموعد'), style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, padding: const EdgeInsets.symmetric(vertical: 14))),
          ] else if (appointment.status == 'مكتمل') ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(onPressed: () => _returnWith('مكتمل'), icon: const Icon(Icons.save_outlined), label: const Text('حفظ الملاحظات')),
          ],
        ]),
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: AppColors.border)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.textPrimary)), const SizedBox(height: 14), ...children]),
  );

  Widget _row(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: Row(children: [Icon(icon, size: 18, color: AppColors.primary), const SizedBox(width: 9), Text('$label: ', style: const TextStyle(color: AppColors.textSecondary)), Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600))) ]),
  );
}
