import 'package:flutter/material.dart';

import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/custom_text_field.dart';
import 'package:se7ety/core/widgets/primary_button.dart';
import 'package:se7ety/features/auth/patient/register/viewmodel/patient_registration_data.dart';

class _Spacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
}

enum ChronicAnswer { yes, no, unknown }

/// الخطوة 2: البيانات الصحية — السن، الطول، الوزن، والأمراض المزمنة
/// (مع إمكانية كتابة اسم المرض لو المريض عنده) — بفاليديشن كامل.
class HealthInfoForm extends StatefulWidget {
  final ValueChanged<PatientHealthData> onSubmit;

  const HealthInfoForm({super.key, required this.onSubmit});

  @override
  State<HealthInfoForm> createState() => _HealthInfoFormState();
}

class _HealthInfoFormState extends State<HealthInfoForm> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _diseaseDetailsController = TextEditingController();
  final _medicalHistoryController = TextEditingController();

  ChronicAnswer? _chronicAnswer;
  bool _chronicError = false;

  // أمراض شائعة للاختيار السريع — بيتم إضافتها لحقل الكتابة تلقائيًا
  final List<String> _quickDiseases = const [
    'السكري',
    'ضغط الدم',
    'أمراض القلب',
    'الربو',
  ];
  final Set<String> _selectedQuickDiseases = {};

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _diseaseDetailsController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  void _toggleQuickDisease(String disease) {
    setState(() {
      if (_selectedQuickDiseases.contains(disease)) {
        _selectedQuickDiseases.remove(disease);
      } else {
        _selectedQuickDiseases.add(disease);
      }

      // نحدّث حقل الكتابة تلقائيًا بالأمراض المختارة من القائمة السريعة
      _diseaseDetailsController.text = _selectedQuickDiseases.join('، ');
      _diseaseDetailsController.selection = TextSelection.collapsed(
        offset: _diseaseDetailsController.text.length,
      );
    });
  }

  void _setChronicAnswer(ChronicAnswer answer) {
    setState(() {
      _chronicAnswer = answer;
      _chronicError = false;
      if (answer != ChronicAnswer.yes) {
        _selectedQuickDiseases.clear();
        _diseaseDetailsController.clear();
      }
    });
  }

  void _handleSubmit() {
    final bool isFormValid = _formKey.currentState!.validate();
    final bool isChronicAnswered = _chronicAnswer != null;

    setState(() => _chronicError = !isChronicAnswered);

    // لو اختار "أيوه" لازم يكتب تفاصيل المرض
    final bool diseaseDetailsOk =
        _chronicAnswer != ChronicAnswer.yes ||
        _diseaseDetailsController.text.trim().isNotEmpty;

    if (isFormValid && isChronicAnswered && diseaseDetailsOk) {
      widget.onSubmit(
        PatientHealthData(
          age: _ageController.text.trim(),
          height: _heightController.text.trim(),
          weight: _weightController.text.trim(),
          chronicDiseaseAnswer: switch (_chronicAnswer!) {
            ChronicAnswer.yes => 'نعم',
            ChronicAnswer.no => 'لا',
            ChronicAnswer.unknown => 'غير متأكد',
          },
          chronicDiseases: _diseaseDetailsController.text.trim(),
          medicalHistory: _medicalHistoryController.text.trim(),
        ),
      );
    } else if (_chronicAnswer == ChronicAnswer.yes && !diseaseDetailsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتب اسم المرض أو تفاصيل عنه')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ===== عنوان القسم =====
          _SectionHeader(
            icon: Icons.favorite_rounded,
            title: 'معلوماتك الصحية',
            subtitle: 'هتساعدنا نقدّملك رعاية أدق',
          ),
          const SizedBox(height: _Spacing.lg),

          // ===== بطاقة: السن / الطول / الوزن =====
          _InfoCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _ageController,
                    label: 'السن',
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'مطلوب';
                      final age = int.tryParse(v.trim());
                      if (age == null || age <= 0 || age > 120) {
                        return 'غير صحيح';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: _Spacing.xs),
                Expanded(
                  child: CustomTextField(
                    controller: _heightController,
                    label: 'الطول',
                    hint: 'سم',
                    icon: Icons.height_rounded,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'مطلوب';
                      final h = num.tryParse(v.trim());
                      if (h == null || h <= 0) return 'غير صحيح';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: _Spacing.xs),
                Expanded(
                  child: CustomTextField(
                    controller: _weightController,
                    label: 'الوزن',
                    hint: 'كجم',
                    icon: Icons.monitor_weight_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'مطلوب';
                      final w = num.tryParse(v.trim());
                      if (w == null || w <= 0) return 'غير صحيح';
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: _Spacing.lg),

          TextField(
            controller: _medicalHistoryController,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'التاريخ المرضي السابق أو الأدوية الحالية',
              hintText: 'اكتب أي أمراض سابقة أو أدوية أو حساسية مهمة',
              prefixIcon: Icon(Icons.history),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: _Spacing.lg),

          // ===== بطاقة: الأمراض المزمنة =====
          _InfoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_information_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: _Spacing.xs),
                    Expanded(
                      child: Text(
                        'هل عندك أمراض مزمنة؟',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: _Spacing.md),

                Row(
                  children: [
                    _ChoiceButton(
                      label: 'أيوه',
                      isSelected: _chronicAnswer == ChronicAnswer.yes,
                      onTap: () => _setChronicAnswer(ChronicAnswer.yes),
                    ),
                    const SizedBox(width: _Spacing.xs + 2), // 10
                    _ChoiceButton(
                      label: 'لأ',
                      isSelected: _chronicAnswer == ChronicAnswer.no,
                      onTap: () => _setChronicAnswer(ChronicAnswer.no),
                    ),
                    const SizedBox(width: _Spacing.xs + 2),
                    _ChoiceButton(
                      label: 'مش عارف',
                      isSelected: _chronicAnswer == ChronicAnswer.unknown,
                      onTap: () => _setChronicAnswer(ChronicAnswer.unknown),
                    ),
                  ],
                ),

                // رسالة خطأ لو مختارش حاجة وضغط إنشاء الحساب
                if (_chronicError)
                  Padding(
                    padding: const EdgeInsets.only(top: _Spacing.xs),
                    child: Text(
                      'اختار إجابة قبل ما تكمل',
                      style: TextStyle(color: AppColors.error, fontSize: 12.5),
                    ),
                  ),

                // يظهر بس لو "أيوه"
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _chronicAnswer == ChronicAnswer.yes
                      ? Padding(
                          padding: const EdgeInsets.only(top: _Spacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'اختيار سريع (اختياري)',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: _Spacing.xs),
                              Wrap(
                                spacing: _Spacing.xs,
                                runSpacing: _Spacing.xs,
                                children: _quickDiseases.map((disease) {
                                  final bool selected = _selectedQuickDiseases
                                      .contains(disease);
                                  return FilterChip(
                                    label: Text(disease),
                                    selected: selected,
                                    onSelected: (_) =>
                                        _toggleQuickDisease(disease),
                                    selectedColor: AppColors.primary.withValues(
                                      alpha: 0.15,
                                    ),
                                    checkmarkColor: AppColors.primary,
                                    labelStyle: TextStyle(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                    ),
                                    backgroundColor: AppColors.background,
                                    side: BorderSide(
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.border,
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: _Spacing.md),

                              // ===== حقل كتابة المرض بالتفصيل =====
                              CustomTextField(
                                controller: _diseaseDetailsController,
                                label: 'اكتب اسم المرض أو تفاصيل إضافية',
                                hint: 'مثال: سكري النوع الثاني',
                                icon: Icons.edit_note_rounded,
                                validator: (v) {
                                  if (_chronicAnswer != ChronicAnswer.yes) {
                                    return null;
                                  }
                                  return (v == null || v.trim().isEmpty)
                                      ? 'اكتب اسم المرض'
                                      : null;
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: _Spacing.lg + 8), // 32
          PrimaryButton(
            label: 'إنشاء الحساب',
            icon: Icons.check_rounded,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// عنوان القسم (أيقونة دائرية + عنوان + وصف)
// ============================================================
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: _Spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// بطاقة موحّدة (خلفية بيضا + حواف مدورة + ظل خفيف)
// ============================================================
class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============================================================
// زرار اختيار (أيوه / لأ / مش عارف)
// ============================================================
class _ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: _Spacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
