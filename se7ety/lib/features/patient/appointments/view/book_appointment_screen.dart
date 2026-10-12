import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/primary_button.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';
import 'package:se7ety/features/doctor/availability/doctor_availability.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';
import 'package:se7ety/features/patient/profile/viewmodel/patient_profile_view_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key, required this.doctorName, required this.specialty});
  final String doctorName;
  final String specialty;

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? _date;
  String? _time;
  final _reason = TextEditingController();

  @override
  void dispose() { _reason.dispose(); super.dispose(); }

  List<DateTime> get _availableDates {
    final today = DateTime.now();
    return [for (var i = 0; i < 30; i++) DateTime(today.year, today.month, today.day + i)]
        .where((date) => DoctorAvailabilityStore.current.weekdays.contains(date.weekday))
        .toList();
  }

  String _dateLabel(DateTime date) {
    const weekdays = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    return '${weekdays[date.weekday - 1]} ${DateFormat('d/M').format(date)}';
  }

  List<String> _slots(DateTime date) {
    final day = DateFormat('yyyy-MM-dd').format(date);
    final booked = DoctorAppointmentsViewModel.appointments
        .where((a) => a.date == day && a.status != 'مرفوض' && a.status != 'ملغي')
        .map((a) => a.time);
    return DoctorAvailabilityStore.slotsFor(date, booked);
  }

  void _book() {
    if (_date == null || _time == null || _reason.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اختار اليوم والوقت واكتب سبب الزيارة')));
      return;
    }
    if (!_slots(_date!).contains(_time)) {
      setState(() => _time = null);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الوقت لم يعد متاحًا، اختار وقتًا آخر')));
      return;
    }
    final patient = PatientProfileViewModel.current;
    final appointment = DoctorAppointment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      patientName: patient.name,
      patientAge: patient.age,
      patientPhone: patient.phone,
      date: DateFormat('yyyy-MM-dd').format(_date!),
      time: _time!,
      reason: _reason.text.trim(),
      status: 'معلق',
      doctorName: widget.doctorName,
      specialty: widget.specialty,
      patientHeight: patient.height,
      patientWeight: patient.weight,
      chronicDiseases: patient.chronicDiseaseAnswer == 'نعم' ? patient.chronicDiseases : patient.chronicDiseaseAnswer,
      medicalHistory: patient.medicalHistory.isEmpty ? 'لا يوجد تاريخ مرضي مسجل' : patient.medicalHistory,
    );
    DoctorAppointmentsViewModel.appointments.add(appointment);
    if (!DoctorPatientsViewModel.patients.any((p) => p.name == patient.name)) {
      DoctorPatientsViewModel.patients.add(DoctorPatient(
        name: patient.name, age: patient.age, phone: patient.phone,
        lastVisit: 'لم يزر العيادة بعد', isPrevious: false, notes: appointment.reason,
        height: patient.height, weight: patient.weight,
        chronicDiseases: appointment.chronicDiseases,
        medicalHistory: appointment.medicalHistory,
      ));
    }
    Navigator.pushReplacementNamed(context, '/patient/booking-confirmation', arguments: appointment);
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: Directionality.of(context),
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('احجز موعدًا')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(widget.doctorName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text(widget.specialty, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 20),
        const Text('اختار يومًا متاحًا', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        if (_availableDates.isEmpty) const Text('الدكتور لم يحدد أيام عمل متاحة حاليًا'),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final date in _availableDates)
            ChoiceChip(
              label: Text(_dateLabel(date)),
              selected: _date == date,
              onSelected: (_) => setState(() { _date = date; _time = null; }),
            ),
        ]),
        if (_date != null) ...[
          const SizedBox(height: 18),
          const Text('اختار وقتًا متاحًا', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          if (_slots(_date!).isEmpty) const Text('لا توجد أوقات متاحة في هذا اليوم'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final slot in _slots(_date!))
              ChoiceChip(label: Text(slot), selected: _time == slot, onSelected: (_) => setState(() => _time = slot)),
          ]),
        ],
        const SizedBox(height: 20),
        TextField(controller: _reason, maxLines: 3, decoration: const InputDecoration(labelText: 'سبب الزيارة', border: OutlineInputBorder())),
        const SizedBox(height: 22),
        PrimaryButton(label: 'تأكيد طلب الحجز', icon: Icons.event_available, onPressed: _book),
      ]),
    ),
  );
}
