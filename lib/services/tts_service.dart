import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static const Map<String, String> _olChikiMap = {
    '᱐': '०', '᱑': '१', '᱒': '२', '᱓': '३', '᱔': '४',
    '᱕': '५', '᱖': '६', '᱗': '७', '᱘': '८', '᱙': '९',
    'ᱚ': 'ओ', 'ᱛ': 'त', 'ᱜ': 'ग', 'ᱝ': 'ंग', 'ᱞ': 'ल',
    'ᱟ': 'आ', 'ᱠ': 'क', 'ᱡ': 'ज', 'ᱢ': 'म', 'ᱣ': 'व',
    'ᱤ': 'इ', 'ᱥ': 'स', 'ᱦ': 'ह', 'ᱧ': 'ञ', 'ᱨ': 'र',
    'ᱩ': 'उ', 'ᱪ': 'च', 'ᱫ': 'द', 'ᱬ': 'ण', 'ᱭ': 'य',
    'ᱮ': 'ए', 'ᱯ': 'प', 'ᱰ': 'ड', 'ᱱ': 'न', 'ᱲ': 'ड़',
    'ᱳ': 'ओ', 'ᱴ': 'ट', 'ᱵ': 'ब', 'ᱶ': 'ंव', 'ᱷ': 'ह',
    'ᱸ': 'ं', 'ᱹ': '', 'ᱺ': 'ं', 'ᱽ': '', 'ᱼ': '',
    '᱾': '।', '᱿': '॥',
  };

  static String olChikiToDevanagari(String input) {
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.runes.length; i++) {
      final char = String.fromCharCode(input.runes.elementAt(i));
      buffer.write(_olChikiMap[char] ?? char);
    }
    return buffer.toString();
  }

  static Future<void> initialize() async {
    await _tts.setSpeechRate(0.42);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  static Future<List<dynamic>> getLanguages() async {
    try {
      return await _tts.getLanguages;
    } catch (_) {
      return [];
    }
  }

  static Future<bool> speakSantali(String text) async {
    if (text.trim().isEmpty) {
      return false;
    }

    await _tts.stop();
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);

    List<dynamic> languages = [];
    try {
      languages = await _tts.getLanguages;
    } catch (_) {}

    bool santaliAvailable = false;
    for (final language in languages) {
      final value = language.toString().toLowerCase();
      if (value.contains('sat') || value.contains('santali')) {
        santaliAvailable = true;
        break;
      }
    }

    if (santaliAvailable) {
      try {
        await _tts.setLanguage('sat-IN');
        await _tts.speak(text);
        return true;
      } catch (_) {}
    }

    // Phonetic fallback: Convert Ol Chiki unicode glyphs to Devanagari phonetics
    // so hi-IN TTS engine reads the Santali words audibly!
    final phoneticText = olChikiToDevanagari(text);
    try {
      await _tts.setLanguage('hi-IN');
    } catch (_) {}

    await _tts.speak(phoneticText.trim().isNotEmpty ? phoneticText : text);

    return false;
  }

  static Future<void> speakHindi(String text) async {
    if (text.trim().isEmpty) {
      return;
    }

    await _tts.stop();
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    try {
      await _tts.setLanguage('hi-IN');
    } catch (_) {}

    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
