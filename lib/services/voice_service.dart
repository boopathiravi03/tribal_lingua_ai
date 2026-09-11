import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText _speech = SpeechToText();

  bool isListening = false;

  Future<bool> initialize() async {
    return await _speech.initialize(
      onStatus: (status) {
        debugPrint('Speech status: $status');
      },
      onError: (error) {
        debugPrint('Speech error: $error');
      },
    );
  }

  Future<void> startListening({
    required Function(String text) onResult,
    required Function() onListening,
    required Function() onStopped,
  }) async {
    final available = await initialize();

    if (!available) {
      throw Exception(
        'Speech recognition is not available.',
      );
    }

    isListening = true;
    onListening();

    await _speech.listen(
      onResult: (result) {
        onResult(result.recognizedWords);

        if (result.finalResult) {
          isListening = false;
          onStopped();
        }
      },
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening = false;
  }

  Future<void> cancelListening() async {
    await _speech.cancel();
    isListening = false;
  }
}
