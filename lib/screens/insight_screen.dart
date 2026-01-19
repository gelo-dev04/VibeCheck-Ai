import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/state.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final insight = AppState.insight.value;
      if (insight == null) return const SizedBox.shrink();

      final moodColor = Color(
        int.parse(insight.moodColor.replaceAll('#', '0xFF')),
      );

      return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [moodColor.withOpacity(0.1), Colors.white],
            ),
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    _buildIcon(insight.spriteExpression, moodColor),
                    const SizedBox(height: 32),
                    Text(
                      'CURRENT VIBE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.slate400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insight.moodName,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.slate800,
                        fontSize: 48,
                      ),
                    ),
                    const SizedBox(height: 48),
                    ...insight.insights
                        .map((text) => _buildInsightCard(text))
                        .toList(),
                    const SizedBox(height: 48),
                    _buildDoneButton(),
                    const SizedBox(height: 120), // Height for nav bar
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildIcon(String expression, Color color) {
    return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Text(
              expression == 'chaotic' ? '⚡' : '🎐',
              style: const TextStyle(fontSize: 64),
            ),
          ),
        )
        .animate()
        .scale(duration: 600.ms, curve: Curves.elasticOut)
        .rotate(begin: -0.1, end: 0);
  }

  Widget _buildInsightCard(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassWidget(
        blur: 10,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.sky600,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.slate800,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildDoneButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => AppState.navigateTo(AppScreen.daily),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.slate800,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        child: const Text(
          'COMPLETE SCAN',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            fontSize: 12,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }
}
