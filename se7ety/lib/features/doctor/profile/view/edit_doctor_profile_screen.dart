import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/custom_text_field.dart';
import 'package:se7ety/core/widgets/primary_button.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';
import 'package:se7ety/features/doctor/availability/doctor_availability.dart';

class EditDoctorProfileScreen extends StatefulWidget {
  const EditDoctorProfileScreen({super.key, required this.profile});

  final DoctorProfile profile;

  @override
  State<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState extends State<EditDoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name);
  late final _specialty = TextEditingController(text: widget.profile.specialty);
  late final _phone = TextEditingController(text: widget.profile.phone);
  late final _clinic = TextEditingController(text: widget.profile.clinic);
  late final _clinicPhone = TextEditingController(
    text: widget.profile.clinicPhone,
  );
  late final _address = TextEditingController(text: widget.profile.address);
  DoctorAvailability _availability = DoctorAvailabilityStore.current;
  late final _about = TextEditingController(text: widget.profile.about);

  @override
  void dispose() {
    _name.dispose();
    _specialty.dispose();
    _phone.dispose();
    _clinic.dispose();
    _clinicPhone.dispose();
    _address.dispose();
    _about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            CustomTextField(
              controller: _name,
              label: 'الاسم',
              icon: Icons.person_outline,
              validator: _required,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _specialty,
              label: 'التخصص',
              icon: Icons.medical_services_outlined,
              validator: _required,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _phone,
              label: 'رقم الهاتف',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: _required,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _clinic,
              label: 'اسم العيادة',
              icon: Icons.local_hospital_outlined,
              validator: _required,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _clinicPhone,
              label: 'هاتف العيادة',
              icon: Icons.phone_in_talk_outlined,
              keyboardType: TextInputType.phone,
              validator: _required,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _address,
              label: 'العنوان',
              icon: Icons.location_on_outlined,
              validator: _required,
            ),
            const SizedBox(height: 12),
            DoctorAvailabilityEditor(value: _availability, onChanged: (value) => _availability = value),
            const SizedBox(height: 22),
            CustomTextField(
              controller: _about,
              label: 'نبذة عنك',
              icon: Icons.info_outline,
              validator: _required,
            ),
            const SizedBox(height: 22),
            PrimaryButton(label: 'حفظ التعديلات', onPressed: _save),
          ],
        ),
      ),
    ),
  );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'الحقل مطلوب' : null;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_availability.weekdays.isEmpty ||
        (_availability.end.hour * 60 + _availability.end.minute) <=
            (_availability.start.hour * 60 + _availability.start.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدد يوم عمل وفترة زمنية صحيحة')),
      );
      return;
    }
    DoctorAvailabilityStore.save(_availability);
    Navigator.pop(
      context,
      widget.profile.copyWith(
        name: _name.text.trim(),
        specialty: _specialty.text.trim(),
        phone: _phone.text.trim(),
        clinic: _clinic.text.trim(),
        clinicPhone: _clinicPhone.text.trim(),
        address: _address.text.trim(),
        workingHours: _availability.summary,
        about: _about.text.trim(),
      ),
    );
  }
}
