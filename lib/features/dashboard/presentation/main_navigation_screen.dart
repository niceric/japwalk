import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';
import '../../statistics/presentation/statistics_screen.dart';

/// Main navigation screen with bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    StatisticsScreen(),
    // Schedule screen will be added in Phase 4
    // Settings screen will be added in Phase 5
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            // Schedule tab - coming in Phase 4
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_today_outlined),
            //   activeIcon: Icon(Icons.calendar_today),
            //   label: 'Schedule',
            // ),
            // Settings tab - coming in Phase 5
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.settings_outlined),
            //   activeIcon: Icon(Icons.settings),
            //   label: 'Settings',
            // ),
          ],
        ),
      ),
    );
  }
}
