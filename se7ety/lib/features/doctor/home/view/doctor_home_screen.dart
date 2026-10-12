import 'package:flutter/material.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/features/doctor/appointments/view/doctor_appointments_screen.dart';
import 'package:se7ety/features/doctor/appointments/viewmodel/doctor_appointment.dart';
import 'package:se7ety/features/doctor/patients/view/doctor_patients_screen.dart';
import 'package:se7ety/features/doctor/profile/view/doctor_profile_screen.dart';
import 'package:se7ety/features/doctor/profile/viewmodel/doctor_profile.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedIndex = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() => _scaffoldKey.currentState?.openDrawer();

  @override
  Widget build(BuildContext context) {
    final pages = [
      _DoctorDashboard(
        onOpenTab: (index) => setState(() => _selectedIndex = index),
        onOpenDrawer: _openDrawer,
      ),
      DoctorAppointmentsScreen(onOpenDrawer: _openDrawer),
      DoctorPatientsScreen(onOpenDrawer: _openDrawer),
      DoctorProfileScreen(onOpenDrawer: _openDrawer),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: SafeArea(
            child: Column(children: [
              const SizedBox(height: 24),
              const CircleAvatar(radius: 34, backgroundColor: Color(0xFFE4F4F1), child: Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 34)),
              const SizedBox(height: 10),
              Text(DoctorProfileViewModel.current.name, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              _drawerItem(Icons.home_outlined, 'الرئيسية', 0),
              _drawerItem(Icons.calendar_month_outlined, 'المواعيد', 1),
              _drawerItem(Icons.people_outline, 'المرضى', 2),
              _drawerItem(Icons.person_outline, 'حسابي', 3),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.error)),
                onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        ),
        body: IndexedStack(index: _selectedIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: 'المواعيد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: 'المرضى',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, int index) => ListTile(
    leading: Icon(icon, color: AppColors.primary),
    title: Text(label),
    selected: _selectedIndex == index,
    onTap: () {
      Navigator.pop(context);
      setState(() => _selectedIndex = index);
    },
  );
}

class _DoctorDashboard extends StatelessWidget {
  const _DoctorDashboard({required this.onOpenTab, required this.onOpenDrawer});

  final ValueChanged<int> onOpenTab;
  final VoidCallback onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    final appointments = DoctorAppointmentsViewModel.appointments
        .where((item) => const {'معلق', 'مؤكد'}.contains(item.status))
        .toList();
    final waiting = appointments.where((item) => item.status == 'معلق').length;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: onOpenDrawer, icon: const Icon(Icons.menu)),
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            tooltip: 'الإشعارات',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.doctorNotifications),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'أهلاً بيك يا دكتور',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'تابع مواعيدك ومرضى عيادتك من هنا.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'مواعيد قادمة',
                  '${appointments.length}',
                  Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  'طلبات جديدة',
                  '$waiting',
                  Icons.mark_email_unread_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'أقرب المواعيد',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => onOpenTab(1),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...appointments
              .take(2)
              .map((item) => _UpcomingCard(appointment: item)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => onOpenTab(2),
            icon: const Icon(Icons.people_outline),
            label: const Text('عرض قائمة المرضى'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 14),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _UpcomingCard extends StatelessWidget {
  const _UpcomingCard({required this.appointment});

  final DoctorAppointment appointment;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.border),
    ),
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFE4F4F1),
        child: Icon(Icons.person_outline, color: AppColors.primary),
      ),
      title: Text(
        appointment.patientName,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${appointment.dateLabel} • ${appointment.time}'),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 15),
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.doctorAppointmentDetails,
        arguments: appointment,
      ),
    ),
  );
}
