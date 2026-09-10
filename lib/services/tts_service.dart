import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> initialize() async {
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  static Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages;
  }

  static Future<bool> speakSantali(String text) async {
    if (text.trim().isEmpty) {
      return false;
    }

    await _tts.stop();

    final languages = await _tts.getLanguages;

    bool santaliAvailable = false;

    for (final language in languages) {
      final value = language.toString().toLowerCase();

      if (value.contains('sat') ||
          value.contains('santali')) {
        santaliAvailable = true;
        break;
      }
    }

    if (santaliAvailable) {
      try {
        await _tts.setLanguage('sat-IN');
      } catch (_) {
        try {
          await _tts.setLanguage('sat');
        } catch (_) {}
      }
    } else {
      await _tts.setLanguage('hi-IN');
    }

    await _tts.speak(text);

    return santaliAvailable;
  }

  static Future<void> speakHindi(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    await _tts.stop();
    await _tts.setLanguage('hi-IN');
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
