import 'package:flutter/material.dart';
import 'package:se7ety/core/constants/app_assets.dart';
import 'package:se7ety/core/routing/app_routes.dart';
import 'package:se7ety/core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, String>> _pages = const [
    {
      'image': AppAssets.onboardingOne,
      'title': 'دور على أفضل الأطباء',
      'description': 'اكتشف دكاترة من كل التخصصات بسهولة وفي أي وقت.',
    },
    {
      'image': AppAssets.onboardingTwo,
      'title': 'احجز موعدك بضغطة واحدة',
      'description': 'اختار الميعاد اللي يناسبك وأكّد الحجز في ثواني.',
    },
    {
      'image': AppAssets.onboardingThree,
      'title': 'تابع حالتك الصحية',
      'description': 'كل معلوماتك الصحية ومواعيدك في مكان واحد.',
    },
  ];
  bool get _isLastPage => _currentPage == _pages.length - 1;
  void _nextPage() {
    if (_isLastPage) {
      _goToWelcome();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousPage() {
    if (_currentPage == 0) return;

    _pageController.previousPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToWelcome() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(context, index, size);
                },
              ),
            ),

            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _currentPage == 0 ? 0 : 1,
            child: IgnorePointer(
              ignoring: _currentPage == 0,
              child: _buildIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: _previousPage,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${_currentPage + 1} / ${_pages.length}',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: _isLastPage ? null : _goToWelcome,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            child: Text(
              'تخطي',
              style: TextStyle(
                color: _isLastPage
                    ? AppColors.textSecondary
                    : AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index, Size size) {
    final page = _pages[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: _buildIllustration(image: page['image']!, size: size),
            ),
          ),

          // ------------------------------------------------------
          // Content Card
          // ------------------------------------------------------
          Expanded(
            flex: 4,
            child: _buildContentCard(
              title: page['title']!,
              description: page['description']!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration({required String image, required Size size}) {
    final double imageSize = size.width * 0.70;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.94, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: imageSize,
        height: imageSize,
        constraints: const BoxConstraints(maxWidth: 330, maxHeight: 330),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(
                255,
                7,
                132,
                120,
              ).withValues(alpha: 0.50),
              blurRadius: 35,
              spreadRadius: 5,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Image.asset(image, fit: BoxFit.contain),
      ),
    );
  }

  // ============================================================
  // Content Card
  // ============================================================

  Widget _buildContentCard({
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
      child: Column(
        children: [
          // Title
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              title,
              key: ValueKey(title),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                height: 1.3,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Description
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              description,
              key: ValueKey(description),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.8,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Bottom Section
  // ============================================================

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          _buildIndicator(),

          const SizedBox(height: 22),

          _buildNextButton(),
        ],
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        final bool active = index == _currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 30 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }

  // ============================================================
  // Next Button
  // ============================================================

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: Row(
            key: ValueKey(_isLastPage),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLastPage ? 'ابدأ الآن' : 'التالي',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 10),

              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isLastPage
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
