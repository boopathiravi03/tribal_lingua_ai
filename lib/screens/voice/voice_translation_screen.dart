import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../services/api_service.dart';
import '../../services/tts_service.dart';

class VoiceTranslationScreen extends StatefulWidget {
  const VoiceTranslationScreen({super.key});

  @override
  State<VoiceTranslationScreen> createState() =>
      _VoiceTranslationScreenState();
}

class _VoiceTranslationScreenState
    extends State<VoiceTranslationScreen> {
  final stt.SpeechToText speech = stt.SpeechToText();

  bool speechAvailable = false;
  bool listening = false;
  bool translating = false;

  String hindiText = '';
  String santaliText = '';

  // true = Hindi → Santali
  // false = Santali → Hindi
  bool hindiToSantali = true;

  @override
  void initState() {
    super.initState();
    initializeSpeech();
  }

  Future<void> initializeSpeech() async {
    final available = await speech.initialize();

    if (!mounted) return;

    setState(() {
      speechAvailable = available;
    });
  }

  Future<void> startListening() async {
    if (!speechAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition is not available.',
          ),
        ),
      );
      return;
    }

    await speech.stop();

    setState(() {
      listening = true;

      if (hindiToSantali) {
        hindiText = '';
      } else {
        santaliText = '';
      }
    });

    await speech.listen(
      localeId: hindiToSantali ? 'hi_IN' : 'sat_IN',
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          if (hindiToSantali) {
            hindiText = result.recognizedWords;
          } else {
            santaliText = result.recognizedWords;
          }
        });
      },
    );
  }

  Future<void> stopListening() async {
    await speech.stop();

    if (!mounted) return;

    setState(() {
      listening = false;
    });

    if (hindiToSantali) {
      if (hindiText.trim().isNotEmpty) {
        await translateHindiToSantali();
      }
    } else {
      if (santaliText.trim().isNotEmpty) {
        await translateSantaliToHindi();
      }
    }
  }

  Future<void> translateHindiToSantali() async {
    setState(() {
      translating = true;
    });

    try {
      final result = await ApiService.translateText(
        text: hindiText,
        sourceLanguage: 'Hindi',
        targetLanguage: 'Santali',
      );

      final translated =
          result['translated_text'] ??
          result['translation'] ??
          result['target_text'] ??
          '';

      if (!mounted) return;

      setState(() {
        santaliText = translated.toString();
        translating = false;
      });

      if (santaliText.trim().isNotEmpty) {
        await TtsService.speakSantali(santaliText);
      }
    } catch (e) {
      showError(e);
    }
  }

  Future<void> translateSantaliToHindi() async {
    setState(() {
      translating = true;
    });

    try {
      final result = await ApiService.translateText(
        text: santaliText,
        sourceLanguage: 'Santali',
        targetLanguage: 'Hindi',
      );

      final translated =
          result['translated_text'] ??
          result['translation'] ??
          result['target_text'] ??
          '';

      if (!mounted) return;

      setState(() {
        hindiText = translated.toString();
        translating = false;
      });

      if (hindiText.trim().isNotEmpty) {
        await TtsService.speakHindi(hindiText);
      }
    } catch (e) {
      showError(e);
    }
  }

  void showError(Object error) {
    if (!mounted) return;

    setState(() {
      translating = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Translation error: $error',
        ),
      ),
    );
  }

  void switchDirection() {
    if (listening || translating) {
      return;
    }

    setState(() {
      hindiToSantali = !hindiToSantali;
      hindiText = '';
      santaliText = '';
    });
  }

  @override
  void dispose() {
    speech.stop();
    TtsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sourceLanguage =
        hindiToSantali ? 'Hindi' : 'Santali';

    final targetLanguage =
        hindiToSantali ? 'Santali' : 'Hindi';

    final sourceText =
        hindiToSantali ? hindiText : santaliText;

    final targetText =
        hindiToSantali ? santaliText : hindiText;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Classroom Voice Translation',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.record_voice_over,
                size: 55,
              ),

              const SizedBox(height: 8),

              const Text(
                'Live Voice Translation',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '$sourceLanguage → $targetLanguage',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 18),

              // Direction switch
              OutlinedButton.icon(
                onPressed: switchDirection,
                icon: const Icon(
                  Icons.swap_horiz,
                ),
                label: Text(
                  'Switch to '
                  '${hindiToSantali ? "Santali → Hindi" : "Hindi → Santali"}',
                ),
              ),

              const SizedBox(height: 18),

              _languageCard(
                title: 'Speaker',
                language: sourceLanguage,
                icon: Icons.person,
                text: sourceText,
              ),

              const SizedBox(height: 12),

              const Icon(
                Icons.arrow_downward,
                size: 28,
              ),

              const SizedBox(height: 12),

              _languageCard(
                title: 'Listener',
                language: targetLanguage,
                icon: Icons.school,
                text: targetText,
              ),

              const Spacer(),

              if (translating)
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text(
                        'Translating...',
                      ),
                    ],
                  ),
                ),

              GestureDetector(
                onTapDown: (_) {
                  startListening();
                },
                onTapUp: (_) {
                  stopListening();
                },
                onTapCancel: () {
                  stopListening();
                },
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                    ),
                  ),
                  child: Icon(
                    listening
                        ? Icons.mic
                        : Icons.mic_none,
                    size: 45,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                listening
                    ? 'Listening... Release to translate'
                    : 'Hold microphone and speak',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              const Text(
                'Voice → Translation → Audio',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageCard({
    required String title,
    required String language,
    required IconData icon,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(language),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            text.isEmpty
                ? 'Waiting for speech...'
                : text,
            style: const TextStyle(
              fontSize: 19,
            ),
          ),
        ],
      ),
    );
  }
}
