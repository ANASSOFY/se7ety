import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';

import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/custom_text_field.dart';
import 'package:se7ety/core/widgets/primary_button.dart';

/// فورم تسجيل الدخول (Email + Password + نسيت كلمة السر + زرار الدخول).
/// مستخدم في شاشة تسجيل دخول المريض.
class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    this.successRoute = AppRoutes.patientHome,
    this.onLoginSuccess,
  });

  final String successRoute;
  final VoidCallback? onLoginSuccess;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final onLoginSuccess = widget.onLoginSuccess;
    if (onLoginSuccess != null) {
      onLoginSuccess();
      return;
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      widget.successRoute,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            controller: _emailController,
            label: 'البريد الإلكتروني',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'اكتب بريدك الإلكتروني';
              }
              if (!value.contains('@')) {
                return 'البريد الإلكتروني غير صحيح';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'كلمة المرور 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
              child: Text(
                'نسيت كلمة المرور؟',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'تسجيل الدخول',
            isLoading: _isLoading,
            onPressed: _handleLogin,
          ),
        ],
      ),
    );
  }
}
