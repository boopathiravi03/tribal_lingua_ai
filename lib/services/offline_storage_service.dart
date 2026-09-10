import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OfflineStorageService {
  static const String lessonKey = 'offline_lesson';
  static const String worksheetKey = 'offline_worksheet';
  static const String flashcardsKey = 'offline_flashcards';

  static Future<void> saveLesson(
    Map<String, dynamic> lesson,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      lessonKey,
      jsonEncode(lesson),
    );
  }

  static Future<Map<String, dynamic>?> getLesson() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(lessonKey);

    if (data == null) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(
        jsonDecode(data),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveWorksheet(
    Map<String, dynamic> worksheet,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      worksheetKey,
      jsonEncode(worksheet),
    );
  }

  static Future<Map<String, dynamic>?>
      getWorksheet() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(
      worksheetKey,
    );

    if (data == null) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(
        jsonDecode(data),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveFlashcards(
    Map<String, dynamic> flashcards,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      flashcardsKey,
      jsonEncode(flashcards),
    );
  }

  static Future<Map<String, dynamic>?>
      getFlashcards() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(
      flashcardsKey,
    );

    if (data == null) {
      return null;
    }

    try {
      return Map<String, dynamic>.from(
        jsonDecode(data),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<bool> hasOfflineContent() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.containsKey(lessonKey) ||
        prefs.containsKey(worksheetKey) ||
        prefs.containsKey(flashcardsKey);
  }

  static Future<void> clearOfflineContent() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(lessonKey);
    await prefs.remove(worksheetKey);
    await prefs.remove(flashcardsKey);
  }
}
