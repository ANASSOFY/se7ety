import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_assets.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:se7ety/features/patient/doctors/view/doctors_screen.dart';
import 'package:se7ety/features/patient/search/view/search_screen.dart';
import 'package:se7ety/features/patient/search/widgets/search_bar.dart';
import 'package:se7ety/core/theme/app_colors.dart';
import 'package:se7ety/core/widgets/doctor_card.dart';
import 'package:se7ety/core/widgets/section_title.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/features/patient/home/viewmodel/patient_home_view_model.dart';
import 'package:se7ety/features/patient/profile/view/patient_profile_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int currentIndex = 0;
  String _searchQuery = '';

  final ZoomDrawerController drawerController = ZoomDrawerController();

  final String _patientName = ' ';

  // ================= Navigation Bar =================

  final List<IconData> iconList = [
    Icons.home_outlined,
    Icons.search_outlined,
    Icons.medical_services_outlined,
    Icons.person_outline,
  ];

  // ================= Specialties =================

  // ألوان التخصصات
  static final List<Color> _specialtyColors = [
    const Color(0xFFFF8A65),
    AppColors.primary,
    const Color(0xFF5B8DEF),
  ];

  // ================= Top Rated Doctors =================

  @override
  void dispose() {
    drawerController.close?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isHomeTab = currentIndex == 0;

    return ZoomDrawer(
      controller: drawerController,
      menuScreen: _buildDrawer(),

      mainScreen: Scaffold(
        backgroundColor: AppColors.background,

        // ================= AppBar =================
        appBar: currentIndex == 1
            ? null
            : AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: AppColors.primary,

                leading: IconButton(
                  onPressed: () {
                    drawerController.toggle?.call();
                  },
                  icon: Icon(Icons.menu, color: AppColors.textOnPrimary),
                ),

                title: Text(
                  PatientHomeViewModel.titles[currentIndex],
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: isHomeTab ? 20 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                actions: [
                  IconButton(
                    onPressed: () {
                      // TODO: Notifications
                    },
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),

        // ================= Body =================
        body: switch (currentIndex) {
          0 => _buildHomeTab(),
          1 => SearchScreen(
            key: ValueKey(_searchQuery),
            initialQuery: _searchQuery,
          ),
          2 => const DoctorsScreen(),
          _ => const PatientProfileScreen(),
        },

        // ================= Booking FAB =================
        floatingActionButton: currentIndex == 1
            ? null
            : FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.patientAppointments),
                backgroundColor: AppColors.primary,
                elevation: 5,
                shape: const CircleBorder(),

                child: Icon(
                  Icons.calendar_month,
                  color: AppColors.textOnPrimary,
                  size: 27,
                ),
              ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // ================= Bottom Navigation =================
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: iconList,
          activeIndex: currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 22,
          rightCornerRadius: 22,
          backgroundColor: Colors.white,
          activeColor: AppColors.primary,
          inactiveColor: Colors.grey,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ================= Welcome =================
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),

              children: [
                const TextSpan(text: 'مرحبًا، '),

                TextSpan(
                  text: _patientName,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'احجز الآن وكن جزءًا من رحلتك الصحية.',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // ================= Search =================
          HomeSearchBar(
            onSubmitted: (query) {
              setState(() {
                _searchQuery = query;
                currentIndex = 1;
              });
            },
          ),

          const SizedBox(height: 26),

          // ================= Specialties =================
          const SectionTitle('التخصصات'),

          const SizedBox(height: 14),

          SizedBox(
            height: 150,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),

              itemCount: PatientHomeViewModel.specialties.length,

              separatorBuilder: (_, _) {
                return const SizedBox(width: 12);
              },

              itemBuilder: (context, index) {
                return _specialtyCard(
                  title: PatientHomeViewModel.specialties[index]['title']!,

                  backgroundColor:
                      _specialtyColors[index % _specialtyColors.length],
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // ================= Top Rated =================
          const SectionTitle('الأعلى تقييمًا'),

          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            itemCount: PatientHomeViewModel.topRatedDoctors.length,

            separatorBuilder: (_, _) {
              return const SizedBox(height: 10);
            },

            itemBuilder: (context, index) {
              final doctor = PatientHomeViewModel.topRatedDoctors[index];

              return _doctorCard(
                name: doctor['name']!,
                specialty: doctor['specialty']!,
                rating: doctor['rating']!,
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SPECIALTY CARD
  // ============================================================

  Widget _specialtyCard({
    required String title,
    required Color backgroundColor,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        // 🔥 الضغط على التخصص يفتح قائمة الأطباء
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.doctorsBySpecialty,
            arguments: title,
          );
        },

        child: Container(
          width: 130,

          padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),

          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Image.asset(
                AppAssets.doctorCard,
                height: 72,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DOCTOR CARD
  // ============================================================

  Widget _doctorCard({
    required String name,
    required String specialty,
    required String rating,
  }) {
    return DoctorCard(
      name: name,
      specialty: specialty,
      rating: rating,
      imageSize: 52,
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.doctorDetails,
        arguments: {'name': name, 'specialty': specialty, 'rating': rating},
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget _buildDrawer() {
    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,

              child: Icon(Icons.person, size: 45, color: AppColors.primary),
            ),

            const SizedBox(height: 15),

            Text(
              'صُحَّتِي',

              style: TextStyle(
                color: AppColors.textOnPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 35),

            // Home
            _drawerItem(
              icon: Icons.home_outlined,
              title: 'الرئيسية',

              onTap: () {
                drawerController.close?.call();

                setState(() {
                  currentIndex = 0;
                });
              },
            ),

            // Doctors
            _drawerItem(
              icon: Icons.medical_services_outlined,
              title: 'الأطباء',

              onTap: () {
                drawerController.close?.call();

                setState(() {
                  currentIndex = 2;
                });
              },
            ),

            // Bookings
            _drawerItem(
              icon: Icons.calendar_month_outlined,
              title: 'الحجوزات',

              onTap: () {
                drawerController.close?.call();

                Navigator.pushNamed(context, AppRoutes.patientAppointments);
              },
            ),

            // Profile
            _drawerItem(
              icon: Icons.person_outline,
              title: 'الملف الشخصي',

              onTap: () {
                drawerController.close?.call();

                setState(() {
                  currentIndex = 3;
                });
              },
            ),

            const Spacer(),

            // Logout
            _drawerItem(
              icon: Icons.logout,
              title: 'تسجيل الخروج',

              onTap: () {
                drawerController.close?.call();
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.welcome, (route) => false);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DRAWER ITEM
  // ============================================================

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 4),

      leading: Icon(icon, color: AppColors.textOnPrimary),

      title: Text(
        title,

        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      onTap: onTap,
    );
  }
}
