import 'package:flutter/material.dart';
import 'package:vibecheck_ai/theme.dart';

class MoodTag {
  final String id;
  final String label;
  final String emoji;
  final Color color;

  MoodTag({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
  });
}

final List<MoodTag> moodTags = [
  MoodTag(id: 'chill', label: 'Chill', emoji: '🎐', color: AppColors.softIris),
  MoodTag(
    id: 'focused',
    label: 'Focused',
    emoji: '🎯',
    color: AppColors.mintyGreen,
  ),
  MoodTag(id: 'chaos', label: 'Chaos', emoji: '⚡', color: AppColors.dustyRose),
  MoodTag(
    id: 'grateful',
    label: 'Grateful',
    emoji: '🙏',
    color: AppColors.pastelHoney,
  ),
  MoodTag(
    id: 'creative',
    label: 'Creative',
    emoji: '🎨',
    color: AppColors.lilac,
  ),
  MoodTag(id: 'tired', label: 'Tired', emoji: '☕', color: AppColors.blueGray),
];
