import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibecheck_ai/theme.dart';
import 'package:vibecheck_ai/constants.dart';
import 'package:vibecheck_ai/state.dart';
import 'package:record/record.dart';
import 'package:vibecheck_ai/services/ai_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final isRecording = signal<bool>(false);
  final showGrid = signal<bool>(false);
  final isProcessing = signal<bool>(false);
  final audioRecorder = AudioRecorder();
  final aiService = VibeAIService();
  final currentMoodColor = signal<String>('#FFFFFF');

  @override
  void dispose() {
    audioRecorder.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/vibe_record.m4a';

      // Clear old file if exists
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }

      await audioRecorder.start(const RecordConfig(), path: path);
      isRecording.value = true;
    }
  }

  Future<void> stopRecording() async {
    final path = await audioRecorder.stop();
    isRecording.value = false;

    if (path != null) {
      isProcessing.value = true;
      try {
        final audioBytes = await File(path).readAsBytes();
        final result = await aiService.processVibe(audioBytes);

        final summary = result['summary'] as String? ?? 'No summary available.';
        final mood = result['mood'] as String? ?? 'Neutral';
        final color = result['color'] as String? ?? '#38BDF8';

        currentMoodColor.value = color;

        AppState.insight.value = VibeInsight(
          moodColor: color,
          moodName: mood,
          insights: [summary],
          spriteExpression: mood.toLowerCase().contains('chaos')
              ? 'chaotic'
              : 'chill',
        );

        // Save to Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('logs').add({
            'userId': user.uid,
            'mood': mood,
            'summary': summary,
            'color': color,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }

        AppState.navigateTo(AppScreen.insight);
      } catch (e) {
        debugPrint('Error processing vibe: $e');
      } finally {
        isProcessing.value = false;
      }
    }
  }

  void handleMicClick() async {
    // Legacy handleMicClick kept for UI sanity if needed, or removed.
    // User wants long press.
  }

  void handleMoodSelect(String mood) {
    // In a real app, this would call Gemini
    // For now, we simulate what App.tsx does
    AppState.isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      AppState.insight.value = VibeInsight(
        moodColor: mood == 'Chaos' ? '#FFB8B8' : '#38BDF8',
        moodName: mood,
        insights: [
          "Your current frequency suggests a state of creative flow.",
          "Environmental factors are aligning with your core energy.",
          "Consider maintaining this vibration for the next 2 hours.",
        ],
        spriteExpression: mood == 'Chaos' ? 'chaotic' : 'chill',
      );
      AppState.isLoading.value = false;
      AppState.navigateTo(AppScreen.insight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return Scaffold(
        backgroundColor: Color(
          int.parse(currentMoodColor.value.replaceAll('#', '0xFF')),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(
                  int.parse(currentMoodColor.value.replaceAll('#', '0xFF')),
                ),
                AppColors.skyBlue.withOpacity(0.05),
              ],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),
                      _buildHeader(),
                      const SizedBox(height: 48),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: showGrid.value
                              ? _buildMoodGrid()
                              : _buildRecordingSection(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isProcessing.value) _buildLoadingOverlay(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showGrid.value)
              IconButton(
                onPressed: () => showGrid.value = false,
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.sky600,
                  size: 28,
                ),
                style:
                    IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      padding: const EdgeInsets.all(12),
                    ).copyWith(
                      side: WidgetStateProperty.all(
                        BorderSide(color: Colors.white.withOpacity(0.8)),
                      ),
                    ),
              )
            else
              const SizedBox(width: 48),
            Expanded(
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium,
                    children: [
                      TextSpan(
                        text: showGrid.value ? 'Select ' : "How's your ",
                      ),
                      const TextSpan(
                        text: 'Aura',
                        style: TextStyle(color: AppColors.sky600),
                      ),
                      const TextSpan(text: '?'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          showGrid.value
              ? 'Pick the tag that resonates most.'
              : 'Capture your energy via voice or tags.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ).animate().fadeIn(duration: 700.ms);
  }

  Widget _buildRecordingSection() {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPressStart: (_) => startRecording(),
              onLongPressEnd: (_) => stopRecording(),
              child:
                  Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isProcessing.value
                              ? const Color(0xFFF8FAFC)
                              : isRecording.value
                              ? AppColors.rose500
                              : AppColors.skyBlue,
                          boxShadow: isProcessing.value
                              ? []
                              : [
                                  BoxShadow(
                                    color:
                                        (isRecording.value
                                                ? AppColors.rose500
                                                : AppColors.skyBlue)
                                            .withOpacity(0.4),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                  BoxShadow(
                                    color:
                                        (isRecording.value
                                                ? AppColors.rose500
                                                : AppColors.skyBlue)
                                            .withOpacity(0.2),
                                    blurRadius: 80,
                                    spreadRadius: 20,
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isProcessing.value
                              ? const CircularProgressIndicator(
                                  color: AppColors.sky600,
                                )
                              : Icon(
                                  isRecording.value
                                      ? Icons.stop_rounded
                                      : Icons.mic_rounded,
                                  color: Colors.white,
                                  size: 56,
                                ),
                        ),
                      )
                      .animate(
                        target: isRecording.value ? 1 : 0,
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scaleXY(
                        begin: 1.0,
                        end: 1.1,
                        duration: 700.ms,
                        curve: Curves.easeInOut,
                      )
                      .animate(target: isProcessing.value ? 1 : 0)
                      .scaleXY(begin: 1.0, end: 0.9, duration: 700.ms),
            ),
            const SizedBox(height: 56),
            Column(
              children: [
                Text(
                      isProcessing.value
                          ? 'Processing Frequency'
                          : isRecording.value
                          ? 'Recording your vibration'
                          : 'Tap to start recording',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isProcessing.value
                            ? AppColors.sky700
                            : isRecording.value
                            ? AppColors.rose600
                            : AppColors.slate600,
                      ),
                    )
                    .animate(
                      target: isRecording.value ? 1 : 0,
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .custom(
                      duration: 700.ms,
                      builder: (context, value, child) =>
                          Opacity(opacity: 0.5 + (value * 0.5), child: child),
                    ),
                const SizedBox(height: 24),
                if (!isRecording.value && !isProcessing.value)
                  OutlinedButton(
                    onPressed: () => showGrid.value = true,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      side: BorderSide(color: Colors.white.withOpacity(0.8)),
                      backgroundColor: Colors.white.withOpacity(0.3),
                    ),
                    child: const Text(
                      'SELECT TAGS INSTEAD',
                      style: TextStyle(
                        color: AppColors.sky700,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Center(
        child: GlassWidget(
          blur: 20,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 1.0,
                      end: 1.2,
                      duration: 800.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scaleXY(
                      begin: 1.2,
                      end: 1.0,
                      duration: 800.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 24),
                const Text(
                  'ANALYZING VIBE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildMoodGrid() {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 40),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: moodTags.length,
      itemBuilder: (context, index) {
        final tag = moodTags[index];
        return GestureDetector(
              onTap: () => handleMoodSelect(tag.label),
              child: GlassWidget(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            tag.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tag.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.slate800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 24,
                        height: 4,
                        decoration: BoxDecoration(
                          color: tag.color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: (index * 100).ms, duration: 500.ms)
            .slideY(begin: 0.2, end: 0);
      },
    );
  }
}
