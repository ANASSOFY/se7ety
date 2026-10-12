import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_assets.dart';
import 'package:se7ety/core/widgets/app_logo.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/routing/app_routes.dart';

class _Spacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.welcomeBackground, fit: BoxFit.cover),
          Container(color: Colors.black.withValues(alpha: 0.35)),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.30),
                                width: 1.2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.30,
                                  ),
                                  blurRadius: 25,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const AppLogo(),
                          ),

                          const SizedBox(height: _Spacing.xl),
                          Text(
                            'أهلاً وسهلاً بك',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.70),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2.5,
                            ),
                          ),

                          const SizedBox(height: _Spacing.sm),

                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'أهلاً بيك في ',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextSpan(
                                  text: 'صحتي',
                                  style: TextStyle(
                                    color: AppColors.primaryLight,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: _Spacing.sm),

                          Text(
                            'رعايتك الصحية أصبحت أسهل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.82),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: _Spacing.xl),

                          // ================= Account Selection =================
                          _buildSelectionContainer(context),

                          const SizedBox(height: _Spacing.lg),

                          // ================= Helper =================
                          Text(
                            'اختار نوع الحساب للمتابعة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    );
  }

  // ============================================================
  // Selection Container
  // ============================================================

  Widget _buildSelectionContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_Spacing.md + 2), // 18
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'اختار نوع الحساب',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: _Spacing.xs / 2), // 4

          Text(
            'حدد نوع الحساب المناسب ليك',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 11.5,
            ),
          ),

          const SizedBox(height: _Spacing.md + 2), // 18

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOption(
                  icon: Icons.person_outline_rounded,
                  title: 'مريض',
                  subtitle: 'احجز موعدك',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.patientLogin);
                  },
                ),
              ),

              const SizedBox(width: _Spacing.sm),

              Expanded(
                child: _buildOption(
                  icon: Icons.medical_services_outlined,
                  title: 'طبيب',
                  subtitle: 'إدارة مواعيدك',
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.doctorLogin);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Account Option
  // ============================================================

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            vertical: _Spacing.md + 1, // 17
            horizontal: _Spacing.xs / 2, // 4
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 27),
              ),

              const SizedBox(height: _Spacing.sm),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.58),
                  fontSize: 10.5,
                ),
              ),

              const SizedBox(height: _Spacing.sm - 2), // 10

              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
