import 'package:flutter/material.dart';
import 'package:se7ety/core/widgets/app_logo.dart';

import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';
import 'package:se7ety/features/doctor/availability/doctor_availability.dart';

class DoctorRegisterScreen extends StatefulWidget {
  const DoctorRegisterScreen({super.key});

  @override
  State<DoctorRegisterScreen> createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  int _step = 0;

  // ===== فورم خاص بكل خطوة — عشان نقدر نتحقق منها لوحدها =====
  final _accountFormKey = GlobalKey<FormState>();
  final _doctorFormKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  final _aboutController = TextEditingController();
  final _clinicAddressController = TextEditingController();
  final _clinicPhoneController = TextEditingController();

  String? _selectedSpecialty;
  DoctorAvailability _availability = DoctorAvailabilityStore.current;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _specialties = [
    'باطنة',
    'أطفال',
    'قلب وأوعية دموية',
    'جلدية',
    'عيون',
    'أسنان',
    'عظام',
    'نساء وتوليد',
    'أنف وأذن وحنجرة',
    'مخ وأعصاب',
    'مسالك بولية',
    'طب نفسي',
    'تغذية',
    'أخرى',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();

    _aboutController.dispose();
    _clinicAddressController.dispose();
    _clinicPhoneController.dispose();

    super.dispose();
  }

  void _nextStep() {
    // التحقق من فورم بيانات الحساب قبل الانتقال للخطوة التالية
    if (_accountFormKey.currentState!.validate()) {
      setState(() {
        _step = 1;
      });
    }
  }

  void _previousStep() {
    if (_step > 0) {
      setState(() {
        _step--;
      });
    }
  }

  void _submit() {
    if (_doctorFormKey.currentState!.validate()) {
      if (_availability.weekdays.isEmpty ||
          (_availability.end.hour * 60 + _availability.end.minute) <=
              (_availability.start.hour * 60 + _availability.start.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدد يوم عمل وفترة زمنية صحيحة')),
        );
        return;
      }
      DoctorAvailabilityStore.save(_availability);
      DoctorProfileViewModel.save(
        DoctorProfile(
          name: _nameController.text.trim(),
          specialty: _selectedSpecialty!,
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          clinic: 'عيادة ${_nameController.text.trim()}',
          clinicPhone: _clinicPhoneController.text.trim(),
          address: _clinicAddressController.text.trim(),
          workingHours: _availability.summary,
          about: _aboutController.text.trim(),
        ),
      );
      Navigator.of(context).pushReplacementNamed(AppRoutes.doctorLogin);
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        icon: icon,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        Expanded(
          child: _buildStepItem(
            number: '1',
            title: 'بيانات الحساب',
            isActive: _step == 0,
            isCompleted: _step > 0,
          ),
        ),
        Container(
          width: 40,
          height: 2,
          color: _step > 0 ? AppColors.primary : AppColors.border,
        ),
        Expanded(
          child: _buildStepItem(
            number: '2',
            title: 'بيانات الطبيب',
            isActive: _step == 1,
            isCompleted: false,
          ),
        ),
      ],
    );
  }

  Widget _buildStepItem({
    required String number,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    final active = isActive || isCompleted;
    final stepColor = isCompleted ? AppColors.success : isActive ? AppColors.primary : AppColors.border;

    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : isCompleted ? AppColors.success.withValues(alpha: .12) : AppColors.surface,
            border: Border.all(color: stepColor),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, color: AppColors.success, size: 21)
                : Text(number, style: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: active ? stepColor : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // خطوة 1: بيانات الحساب — فورم مستقل بالتحقق بتاعه
  // ============================================================
  Widget _buildAccountStep() {
    return Form(
      key: _accountFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'الاسم بالكامل',
            icon: Icons.person_outline_rounded,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب اسمك بالكامل' : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
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
          const SizedBox(height: 14),

          _buildTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
            ),
            validator: (v) => (v == null || v.length < 6)
                ? 'كلمة المرور 6 أحرف على الأقل'
                : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _confirmPasswordController,
            label: 'تأكيد كلمة المرور',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
            ),
            validator: (v) => (v != _passwordController.text)
                ? 'كلمة المرور غير متطابقة'
                : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _phoneController,
            label: 'رقم الهاتف',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().length < 10)
                ? 'رقم هاتف غير صحيح'
                : null,
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'التالي',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // خطوة 2: بيانات الطبيب والعيادة — فورم مستقل بالتحقق بتاعه
  // ============================================================
  Widget _buildDoctorStep() {
    return Form(
      key: _doctorFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedSpecialty,
            decoration: _inputDecoration(
              label: 'التخصص',
              icon: Icons.medical_services_outlined,
            ),
            items: _specialties.map((specialty) {
              return DropdownMenuItem(value: specialty, child: Text(specialty));
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedSpecialty = value);
            },
            validator: (v) => v == null ? 'اختار تخصصك' : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _aboutController,
            label: 'نبذة عنك',
            icon: Icons.info_outline_rounded,
            maxLines: 4,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب نبذة مختصرة عنك' : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _clinicAddressController,
            label: 'عنوان العيادة',
            icon: Icons.location_on_outlined,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'اكتب عنوان العيادة' : null,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _clinicPhoneController,
            label: 'رقم العيادة',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) => (v == null || v.trim().length < 8)
                ? 'رقم عيادة غير صحيح'
                : null,
          ),
          const SizedBox(height: 14),

          DoctorAvailabilityEditor(
            value: _availability,
            onChanged: (value) => _availability = value,
          ),
          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'إنشاء الحساب',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      if (_step == 1) {
                        _previousStep();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const AppLogo(),
                                ),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                'سجل حساب ك "دكتور"',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                _step == 0
                                    ? 'أنشئ حسابك وابدأ في تقديم خدماتك الطبية'
                                    : 'أضف معلوماتك الطبية والعيادة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),

                              const SizedBox(height: 24),

                              _buildStepIndicator(),

                              const SizedBox(height: 28),

                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: _step == 0
                                    ? _buildAccountStep()
                                    : _buildDoctorStep(),
                              ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
