import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/state.dart';
import 'package:vibecheck_ai/screens/home_page.dart';
import 'package:vibecheck_ai/screens/insight_screen.dart';
import 'package:vibecheck_ai/screens/auth/login_page.dart';
import 'package:vibecheck_ai/screens/auth/signup_page.dart';
import 'package:vibecheck_ai/screens/history/history_page.dart';
import 'package:vibecheck_ai/screens/history/history_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeCheck AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final currentScreen = AppState.currentScreen.value;
      final isAuthenticated = AppState.isAuthenticated.value;
      final isLoading = AppState.isLoading.value;

      return Scaffold(
        body: Stack(
          children: [
            // Screen Content
            Positioned.fill(child: _buildScreen(currentScreen)),

            // Loading Overlay
            if (isLoading) _buildLoadingOverlay(),

            // Navigation Bar
            if (isAuthenticated &&
                currentScreen != AppScreen.login &&
                currentScreen != AppScreen.signup)
              FloatingNavBar(currentScreen: currentScreen),
          ],
        ),
      );
    });
  }

  Widget _buildScreen(AppScreen screen) {
    switch (screen) {
      case AppScreen.login:
        return const LoginPage();
      case AppScreen.signup:
        return const SignupPage();
      case AppScreen.daily:
        return const HomePage();
      case AppScreen.insight:
        return const InsightScreen();
      case AppScreen.history:
        return const HistoryPage();
      case AppScreen.historyDetail:
        return const HistoryDetailPage();
      case AppScreen.profile:
        return _buildProfilePlaceholder();
    }
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 64,
              backgroundColor: Colors.white,
              child: Text('👤', style: TextStyle(fontSize: 64)),
            ).animate().scale(duration: 500.ms),
            const SizedBox(height: 24),
            const Text(
              'Aura Explorer',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'LEVEL 1 VIBE ARCHITECT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 48),
            _buildInfoCard('SUBSCRIPTION STATUS', 'Standard Frequency'),
            const SizedBox(height: 16),
            _buildInfoCard('PRIVACY & SECURITY', 'Biometric Locked'),
            const SizedBox(height: 64),
            TextButton(
              onPressed: () => AppState.logout(),
              child: const Text(
                'DE-SYNCHRONIZE SESSION',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return GlassWidget(
      blur: 10,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.slate400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100, width: 4),
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 4,
                color: AppColors.sky600,
              ),
            ).animate(onPlay: (c) => c.repeat()).rotate(duration: 2.seconds),
            const SizedBox(height: 32),
            const Text(
                  'SYNCING NEURAL CORE',
                  style: TextStyle(
                    color: AppColors.sky700,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                    fontSize: 11,
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeOut(duration: 800.ms)
                .fadeIn(duration: 800.ms),
            const SizedBox(height: 8),
            const Text(
              'PLEASE HOLD YOUR FREQUENCY',
              style: TextStyle(
                color: AppColors.slate600,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingNavBar extends StatelessWidget {
  final AppScreen currentScreen;
  const FloatingNavBar({super.key, required this.currentScreen});

  @override
  Widget build(BuildContext context) {
    return Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: GlassWidget(
                blur: 24,
                borderRadius: BorderRadius.circular(100),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.skyBlue.withValues(alpha: 0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavButton(
                        icon: Icons.mic_rounded,
                        isActive:
                            currentScreen == AppScreen.daily ||
                            currentScreen == AppScreen.insight,
                        onTap: () => AppState.navigateTo(AppScreen.daily),
                      ),
                      _NavButton(
                        icon: Icons.calendar_today_rounded,
                        isActive:
                            currentScreen == AppScreen.history ||
                            currentScreen == AppScreen.historyDetail,
                        onTap: () => AppState.navigateTo(AppScreen.history),
                      ),
                      _NavButton(
                        icon: Icons.person_rounded,
                        isActive: currentScreen == AppScreen.profile,
                        onTap: () => AppState.navigateTo(AppScreen.profile),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 700.ms)
        .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic);
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 56,
        height: 56,
        transform: Matrix4.identity()..scale(isActive ? 1.1 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.sky600 : Colors.transparent,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.sky600.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.slate600,
          size: 24,
        ),
      ),
    );
  }
}
