import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _codeSent = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose(); _code.dispose(); _password.dispose(); _confirm.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _codeSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('وضع التجربة: استخدم رمز OTP ‏123456 إلى أن يتم توصيل الـ API')),
    );
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) return;
    if (_code.text.trim() != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز التحقق غير صحيح')));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تغيير كلمة المرور تجريبيًا. اربط العملية بالـ API عند توفره.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('استعادة كلمة المرور')),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('اكتب بريدك الإلكتروني لإعادة تعيين كلمة المرور.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 18),
          TextFormField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_outlined), border: OutlineInputBorder()), validator: (value) => value == null || !value.contains('@') ? 'اكتب بريدًا إلكترونيًا صحيحًا' : null),
          if (_codeSent) ...[
            const SizedBox(height: 14),
            TextFormField(controller: _code, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'رمز OTP', prefixIcon: Icon(Icons.verified_user_outlined), border: OutlineInputBorder()), validator: (value) => value == null || value.trim().length != 6 ? 'أدخل الرمز المكون من 6 أرقام' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _password, obscureText: _obscure, decoration: InputDecoration(labelText: 'كلمة المرور الجديدة', prefixIcon: const Icon(Icons.lock_outline), border: const OutlineInputBorder(), suffixIcon: IconButton(onPressed: () => setState(() => _obscure = !_obscure), icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined))), validator: (value) => value == null || value.length < 6 ? 'كلمة المرور 6 أحرف على الأقل' : null),
            const SizedBox(height: 14),
            TextFormField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور', prefixIcon: Icon(Icons.lock_outline), border: OutlineInputBorder()), validator: (value) => value != _password.text ? 'كلمتا المرور غير متطابقتين' : null),
          ],
          const SizedBox(height: 22),
          FilledButton(onPressed: _codeSent ? _resetPassword : _sendCode, child: Text(_codeSent ? 'تأكيد وتغيير كلمة المرور' : 'إرسال رمز التحقق')),
          if (_codeSent) TextButton(
            onPressed: () {
              setState(() => _codeSent = false);
              _sendCode();
            },
            child: const Text('إرسال الرمز مرة أخرى'),
          ),
          const SizedBox(height: 12),
          const Text('الاستعادة هنا محاكاة محلية؛ لن يصل بريد أو SMS قبل ربط خدمة الباك إند.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ]),
      ))),
    ),
  );
}
