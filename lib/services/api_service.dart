import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // Android emulator:
  // http://10.0.2.2:8000
  //
  // Physical Android phone:
  // use your computer's LAN IP, for example:
  // http://192.168.1.23:8000
  //
  // You can override this at run time using:
  // flutter run --dart-define=API_BASE_URL=http://YOUR_PC_IP:8000

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://tribal-lingua-ai.onrender.com',
  );


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
      translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {

    final response = await http.post(
      Uri.parse('$baseUrl/translate'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'text': text,
        'source_language': sourceLanguage,
        'target_language': targetLanguage,
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
    String grade = 'Grade 1',
    String learningOutcome =
        'Recognises and counts numbers',
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
        'grade': grade,
        'learning_outcome': learningOutcome,
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
