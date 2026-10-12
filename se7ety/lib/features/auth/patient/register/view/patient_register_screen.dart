import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_assets.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/auth/patient/register/widgets/health_info_form.dart';
import 'package:se7ety/features/auth/patient/register/widgets/personal_info_form.dart';
import 'package:se7ety/features/auth/patient/register/viewmodel/patient_registration_data.dart';
import 'package:se7ety/features/patient/profile/viewmodel/patient_profile_view_model.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/features/doctor/patients/viewmodel/doctor_patient.dart';

class PatientRegisterScreen extends StatefulWidget {
  const PatientRegisterScreen({super.key});

  @override
  State<PatientRegisterScreen> createState() => _PatientRegisterScreenState();
}

class _PatientRegisterScreenState extends State<PatientRegisterScreen> {
  int _step = 0;
  PatientAccountData? _accountData;

  void _goToStep(int step) {
    setState(() {
      _step = step;
    });
  }

  void _submit(PatientHealthData healthData) {
    final accountData = _accountData;
    if (accountData == null) return;

    final profile = PatientProfileData(
        name: accountData.name,
        email: accountData.email,
        phone: accountData.phone,
        age: '${healthData.age} سنة',
        height: '${healthData.height} سم',
        weight: '${healthData.weight} كجم',
        chronicDiseaseAnswer: healthData.chronicDiseaseAnswer,
        chronicDiseases: healthData.chronicDiseases,
        medicalHistory: healthData.medicalHistory,
      );
    PatientProfileViewModel.save(profile);
    DoctorPatientsViewModel.patients.removeWhere((patient) => patient.name == profile.name);
    DoctorPatientsViewModel.patients.add(DoctorPatient(
      name: profile.name,
      age: profile.age,
      phone: profile.phone,
      lastVisit: 'لم يزر العيادة بعد',
      isPrevious: false,
      notes: 'مريض مسجل حديثًا',
      height: profile.height,
      weight: profile.weight,
      chronicDiseases: profile.chronicDiseaseAnswer == 'نعم'
          ? profile.chronicDiseases
          : profile.chronicDiseaseAnswer,
      medicalHistory: profile.medicalHistory.isEmpty
          ? 'لا يوجد تاريخ مرضي مسجل'
          : profile.medicalHistory,
    ));
    Navigator.of(context).pushReplacementNamed(AppRoutes.patientLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              // =========================
              // Back Button
              // =========================
              Positioned(top: 12, right: 16, child: _buildBackButton()),

              // =========================
              // Main Content
              // =========================
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 30,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // =========================
                        // Logo
                        // =========================
                        _buildLogo(),

                        const SizedBox(height: 18),

                        // =========================
                        // Title
                        // =========================
                        Text(
                          'سجل حساب ك "مريض"',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // =========================
                        // Subtitle
                        // =========================
                        Text(
                          _step == 0
                              ? 'أنشئ حسابك وابدأ رحلتك الصحية'
                              : 'ساعدنا نعرف معلوماتك الصحية بشكل أفضل',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // =========================
                        // Step Indicator
                        // =========================
                        _buildStepIndicator(),

                        const SizedBox(height: 24),

                        // =========================
                        // Forms
                        // =========================
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: _step == 0
                              ? PersonalInfoForm(
                                  key: const ValueKey('personal'),
                                  onNext: (accountData) {
                                    _accountData = accountData;
                                    _goToStep(1);
                                  },
                                )
                              : HealthInfoForm(
                                  key: const ValueKey('health'),
                                  onSubmit: _submit,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Logo
  // =========================
  Widget _buildLogo() {
    return Container(
      width: 105,
      height: 105,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
    );
  }

  // =========================
  // Back Button
  // =========================
  Widget _buildBackButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (_step == 0) {
            Navigator.of(context).maybePop();
          } else {
            _goToStep(0);
          }
        },
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.textPrimary,
            size: 21,
          ),
        ),
      ),
    );
  }

  // =========================
  // Step Indicator
  // =========================
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStep(number: '1', title: 'بيانات الحساب', active: _step == 0),

        Container(
          width: 45,
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: AppColors.border,
        ),

        _buildStep(number: '2', title: 'البيانات الصحية', active: _step == 1),
      ],
    );
  }

  // =========================
  // Single Step
  // =========================
  Widget _buildStep({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? AppColors.primary : AppColors.surface,
            border: Border.all(
              color: active ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active ? Colors.white : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: TextStyle(
            color: active ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
