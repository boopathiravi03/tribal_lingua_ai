import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ============================================================
  // BACKEND CONFIGURATION
  // ============================================================
  //
  // Render is the primary backend.
  //
  // For local laptop testing:
  //
  // flutter run --dart-define=API_BASE_URL=http://192.168.1.23:8000
  //
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://tribal-lingua-ai.onrender.com',
  );

  static const Duration timeout = Duration(seconds: 120);

  // ============================================================
  // COMMON POST METHOD
  // ============================================================

  static Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return {};
        }

        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        return {
          'data': decoded,
        };
      }

      String message = 'Server error ${response.statusCode}';

      try {
        final errorBody = jsonDecode(response.body);

        if (errorBody is Map && errorBody['detail'] != null) {
          message = errorBody['detail'].toString();
        }
      } catch (_) {}

      throw Exception(message);
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Unable to connect to backend: $e');
    }
  }

  // ============================================================
  // HEALTH CHECK
  // ============================================================

  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 20));

      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ============================================================
  // HINDI ↔ SANTALI TRANSLATION
  // ============================================================

  static Future<Map<String, dynamic>> translate({
    required String text,
    String sourceLanguage = 'hi',
    String targetLanguage = 'sat',
  }) async {
    return _post(
      '/translate',
      {
        'text': text,
        'source_language': sourceLanguage,
        'target_language': targetLanguage,
      },
    );
  }

  static Future<Map<String, dynamic>> translateText({
    required String text,
    String sourceLanguage = 'hi',
    String targetLanguage = 'sat',
  }) async {
    return translate(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  // ============================================================
  // AI LESSON GENERATOR
  // ============================================================

  static Future<Map<String, dynamic>> generateLesson({
    required String className,
    required String subject,
    required String lesson,
    String targetLanguage = 'Santali',
  }) async {
    return _post(
      '/lesson/generate',
      {
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
        'target_language': targetLanguage,
      },
    );
  }

  // ============================================================
  // WORKSHEET GENERATOR
  // ============================================================

  static Future<Map<String, dynamic>> generateWorksheet({
    required String className,
    required String subject,
    required String lesson,
    required String grade,
    required String learningOutcome,
  }) async {
    return _post(
      '/worksheet/generate',
      {
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
        'grade': grade,
        'learning_outcome': learningOutcome,
      },
    );
  }

  // ============================================================
  // FLASHCARD GENERATOR
  // ============================================================

  static Future<Map<String, dynamic>> generateFlashcards({
    required String className,
    required String subject,
    required String lesson,
  }) async {
    return _post(
      '/flashcards/generate',
      {
        'class_name': className,
        'subject': subject,
        'lesson': lesson,
      },
    );
  }
}
