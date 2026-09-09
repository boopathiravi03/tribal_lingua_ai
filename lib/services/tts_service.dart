import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
  }

  Future<List<dynamic>> getAvailableLanguages() async {
    return await _tts.getLanguages;
  }

  Future<bool> isLanguageAvailable(String language) async {
    return await _tts.isLanguageAvailable(language);
  }

  Future<void> speak({
    required String text,
    required String language,
  }) async {
    await initialize();

    final available =
        await _tts.isLanguageAvailable(language);

    if (!available) {
      throw Exception(
        'TTS language $language is not available '
        'on this device.',
      );
    }

    await _tts.setLanguage(language);
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
