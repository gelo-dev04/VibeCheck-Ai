import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/state.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final isPremium = AppState.isPremium.value;

      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // History Content (Blurred if not premium)
            Positioned.fill(child: _buildHistoryContent(context, !isPremium)),

            // Premium Overlay
            if (!isPremium) _buildPremiumOverlay(context),
          ],
        ),
      );
    });
  }

  Widget _buildHistoryContent(BuildContext context, bool blurred) {
    return Opacity(
          opacity: blurred ? 0.4 : 1.0,
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                  child: _buildHeader(context),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 120,
                  ),
                  itemCount: AppState.mockHistory.length,
                  itemBuilder: (context, index) {
                    final entry = AppState.mockHistory[index];
                    return _buildHistoryEntry(context, entry);
                  },
                ),
              ),
            ],
          ),
        )
        .animate(target: blurred ? 1 : 0)
        .blur(begin: Offset.zero, end: const Offset(80, 80));
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 32),
            children: [
              const TextSpan(text: 'Weekly '),
              const TextSpan(
                text: 'Trends',
                style: TextStyle(color: AppColors.sky600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Reflecting on your emotional journey.',
          style: TextStyle(
            color: AppColors.slate600,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryEntry(BuildContext context, HistoryEntry entry) {
    final entryColor = Color(int.parse(entry.color.replaceAll('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          AppState.selectedHistoryEntry.value = entry;
          AppState.navigateTo(AppScreen.historyDetail);
        },
        child: GlassWidget(
          blur: 10,
          borderRadius: BorderRadius.circular(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: entryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.mood,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.date.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.slate400,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.sky600,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumOverlay(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: GlassWidget(
            blur: 20,
            borderRadius: BorderRadius.circular(44),
            decoration: GlassDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(44),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.skyBlue, Colors.blue],
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Unlock History',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.slate800,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'See how your vibes evolve over time. Unlock 365-day tracking and exclusive Vibe Sprite forms.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.slate600,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () => AppState.isPremium.value = true,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sky600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Go Premium — \$2.99',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'RESTORE PURCHASE',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.slate400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 1.seconds).slideY(begin: 0.1, end: 0);
  }
}
