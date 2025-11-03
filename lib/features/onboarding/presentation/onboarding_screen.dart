import 'package:flutter/material.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';
import '../../../core/constants/app_strings.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

/// Onboarding screen with 3 swipeable pages
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: AppStrings.onboardingWelcomeTitle,
      description: AppStrings.onboardingWelcomeDescription,
      icon: Icons.flag,
      gradient: const [Color(0xFFDC143C), Color(0xFFFF6B6B)],
    ),
    OnboardingPageData(
      title: AppStrings.onboardingHowItWorksTitle,
      description: AppStrings.onboardingHowItWorksDescription,
      icon: Icons.directions_walk,
      gradient: const [Color(0xFF42A5F5), Color(0xFF64B5F6)],
    ),
    OnboardingPageData(
      title: AppStrings.onboardingPermissionsTitle,
      description: AppStrings.onboardingPermissionsDescription,
      icon: Icons.notifications_active,
      gradient: const [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    ),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onSkip() {
    _navigateToDashboard();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    isLastPage ? '' : AppStrings.skip,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: PageIndicator(
                currentPage: _currentPage,
                pageCount: _pages.length,
              ),
            ),
            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isLastPage ? AppStrings.getStarted : AppStrings.next,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for onboarding page
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
