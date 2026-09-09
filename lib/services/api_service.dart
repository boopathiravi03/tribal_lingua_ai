import 'dart:convert';

import 'package:http/http.dart' as http;


class ApiService {

  // Android emulator:
  // 10.0.2.2 points to your computer's localhost.

  static const String baseUrl =
      'http://10.0.2.2:8000';


  static Future<Map<String, dynamic>>
      translate({
    required String text,
    required String targetLanguage,
    required String className,
    required String subject,
    required String lesson,
  }) async {

    final response = await http.post(
      Uri.parse('$baseUrl/translate'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'text': text,
        'source_language': 'Hindi',
        'target_language': targetLanguage,
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
      }),
    );


    if (response.statusCode != 200) {
      throw Exception(
        'Translation failed: ${response.body}',
      );
    }


    return jsonDecode(response.body);
  }


  static Future<Map<String, dynamic>>
      generateLesson({
    required String className,
    required String subject,
    required String lesson,
    required String targetLanguage,
  }) async {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/lesson/generate',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
        'target_language': targetLanguage,
      }),
    );


    if (response.statusCode != 200) {
      throw Exception(
        'Lesson generation failed: '
        '${response.body}',
      );
    }


    return jsonDecode(
      response.body,
    );
  }


  static Future<Map<String, dynamic>>
      generateWorksheet({
    required String className,
    required String subject,
    required String lesson,
    required String targetLanguage,
  }) async {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/worksheet/generate',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
        'target_language': targetLanguage,
      }),
    );


    if (response.statusCode != 200) {
      throw Exception(
        'Worksheet generation failed: '
        '${response.body}',
      );
    }


    return jsonDecode(
      response.body,
    );
  }


  static Future<Map<String, dynamic>>
      generateFlashcards({
    required String className,
    required String subject,
    required String lesson,
    required String targetLanguage,
  }) async {

    final response = await http.post(
      Uri.parse(
        '$baseUrl/flashcards/generate',
      ),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
        'target_language':
            targetLanguage,
      }),
    );


    if (response.statusCode != 200) {
      throw Exception(
        'Flashcard generation failed: '
        '${response.body}',
      );
    }


    return jsonDecode(
      response.body,
    );
  }
}
