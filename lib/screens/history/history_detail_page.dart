import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/state.dart';
import 'package:vibecheck_ai/widgets/vibe_sprite.dart';

class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      final entry = AppState.selectedHistoryEntry.value;
      if (entry == null)
        return const Scaffold(body: Center(child: Text("No entry selected")));

      final entryColor = Color(int.parse(entry.color.replaceAll('#', '0xFF')));
      final mockInsights = [
        "On this day, you were feeling primarily ${entry.mood}.",
        "The data suggests a strong connection between your morning activity and this state.",
        "Synchronized frequencies were at an all-time peak during this period.",
      ];

      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Header with Sprite
            _buildStickyHeader(context, entry, entryColor),

            // Insights Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                child: Column(
                  children: [
                    GlassWidget(
                      blur: 10,
                      borderRadius: BorderRadius.circular(40),
                      decoration: GlassDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ARCHIVED INSIGHTS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: AppColors.slate400,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ...mockInsights
                                .map(
                                  (text) => _buildInsightItem(text, entryColor),
                                )
                                .toList(),
                            const SizedBox(height: 48),
                            _buildReturnButton(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStickyHeader(
    BuildContext context,
    HistoryEntry entry,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Subtle gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              VibeSprite(
                expression: entry.mood == 'Hectic' || entry.mood == 'Chaos'
                    ? 'chaotic'
                    : 'chill',
                color: Colors.white,
                size: 140,
              ),
              const SizedBox(height: 32),
              Text(
                entry.mood,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: AppColors.slate800,
                  letterSpacing: -2.0,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  entry.date.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.slate800,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms);
  }

  Widget _buildInsightItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.slate800,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton(
        onPressed: () => AppState.navigateTo(AppScreen.history),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          side: const BorderSide(color: Color(0xFFE2E8F0)), // sky-200
          backgroundColor: Colors.white.withValues(alpha: 0.3),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_rounded, color: AppColors.sky600),
            SizedBox(width: 8),
            Text(
              'RETURN TO TRENDS',
              style: TextStyle(
                color: AppColors.sky700,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
