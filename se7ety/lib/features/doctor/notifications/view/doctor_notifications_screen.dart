import 'package:flutter/material.dart';
import 'package:se7ety/core/theme/app_colors.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  static const _notifications = [
    (
      'طلب موعد جديد',
      'محمد أحمد طلب حجز موعد يوم 15 أكتوبر.',
      Icons.calendar_month_outlined,
    ),
    ('تم تأكيد موعد', 'تم تأكيد موعد سارة محمود.', Icons.check_circle_outline),
    (
      'تذكير',
      'لديك موعد اليوم الساعة 5:30 مساءً.',
      Icons.notifications_none_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('الإشعارات')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _notifications.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final item = _notifications[index];
          return Card(
            color: AppColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(item.$3, color: AppColors.primary),
              ),
              title: Text(
                item.$1,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(item.$2),
              ),
            ),
          );
        },
      ),
    ),
  );
}
