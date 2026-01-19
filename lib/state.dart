import 'package:signals_flutter/signals_flutter.dart';

enum AppScreen {
  login,
  signup,
  daily,
  insight,
  history,
  historyDetail,
  profile,
}

class VibeInsight {
  final String moodColor;
  final String moodName;
  final List<String> insights;
  final String spriteExpression;

  VibeInsight({
    required this.moodColor,
    required this.moodName,
    required this.insights,
    required this.spriteExpression,
  });
}

class HistoryEntry {
  final String id;
  final String date;
  final String mood;
  final String color;

  HistoryEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.color,
  });
}

class AppState {
  static final currentScreen = signal<AppScreen>(AppScreen.login);
  static final isLoading = signal<bool>(false);
  static final insight = signal<VibeInsight?>(null);
  static final isAuthenticated = signal<bool>(false);
  static final isPremium = signal<bool>(false);
  static final selectedHistoryEntry = signal<HistoryEntry?>(null);

  static final mockHistory = [
    HistoryEntry(
      id: '1',
      date: 'Monday, Feb 10',
      mood: 'Balanced',
      color: '#B4BCFF',
    ),
    HistoryEntry(
      id: '2',
      date: 'Tuesday, Feb 11',
      mood: 'Hectic',
      color: '#FFB8B8',
    ),
    HistoryEntry(
      id: '3',
      date: 'Wednesday, Feb 12',
      mood: 'Peaceful',
      color: '#D6DBFF',
    ),
    HistoryEntry(
      id: '4',
      date: 'Thursday, Feb 13',
      mood: 'Productive',
      color: '#E0C3FC',
    ),
    HistoryEntry(
      id: '5',
      date: 'Friday, Feb 14',
      mood: 'Vibrant',
      color: '#FEE5A5',
    ),
    HistoryEntry(
      id: '6',
      date: 'Saturday, Feb 15',
      mood: 'Mellow',
      color: '#A5B4FC',
    ),
    HistoryEntry(
      id: '7',
      date: 'Sunday, Feb 16',
      mood: 'Grateful',
      color: '#FFD1DC',
    ),
  ];

  static void navigateTo(AppScreen screen) {
    currentScreen.value = screen;
  }

  static void login() {
    isAuthenticated.value = true;
    currentScreen.value = AppScreen.daily;
  }

  static void logout() {
    isAuthenticated.value = false;
    currentScreen.value = AppScreen.login;
  }
}
