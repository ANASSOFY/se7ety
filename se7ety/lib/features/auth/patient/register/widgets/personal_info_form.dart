import 'package:flutter/material.dart';

import 'package:se7ety/core/widgets/custom_text_field.dart';
import 'package:se7ety/core/widgets/primary_button.dart';
import 'package:se7ety/features/auth/patient/register/viewmodel/patient_registration_data.dart';

/// الخطوة 1: بيانات الحساب (الاسم، الإيميل، التليفون، الباسورد).
class PersonalInfoForm extends StatefulWidget {
  final ValueChanged<PatientAccountData> onNext;

  const PersonalInfoForm({super.key, required this.onNext});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(
        PatientAccountData(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'الاسم بالكامل',
            icon: Icons.person_outline_rounded,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب اسمك بالكامل' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            label: 'البريد الإلكتروني',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'اكتب بريدك الإلكتروني';
              if (!v.contains('@')) return 'البريد الإلكتروني غير صحيح';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _phoneController,
            label: 'رقم التليفون',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'رقم تليفون غير صحيح'
                : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (v) => (v == null || v.length < 6)
                ? 'كلمة المرور 6 أحرف على الأقل'
                : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _confirmPasswordController,
            label: 'تأكيد كلمة المرور',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (v) {
              if (v != _passwordController.text) {
                return 'كلمة المرور غير متطابقة';
              }
              return null;
            },
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            label: 'التالي',
            icon: Icons.arrow_back_rounded,
            onPressed: _handleNext,
          ),
        ],
      ),
    );
  }
}
