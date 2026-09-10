import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../services/api_service.dart';
import '../../services/tts_service.dart';

class ClassroomModeScreen extends StatefulWidget {
  const ClassroomModeScreen({super.key});

  @override
  State<ClassroomModeScreen> createState() =>
      _ClassroomModeScreenState();
}

class _ClassroomModeScreenState
    extends State<ClassroomModeScreen> {
  final stt.SpeechToText speech = stt.SpeechToText();

  bool speechAvailable = false;
  bool listening = false;
  bool translating = false;

  String hindiText = '';
  String santaliText = '';

  bool teacherMode = true;

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

      if (teacherMode) {
        hindiText = '';
      } else {
        santaliText = '';
      }
    });

    await speech.listen(
      localeId: teacherMode ? 'hi_IN' : 'sat_IN',
      onResult: (result) {
        if (!mounted) return;

        setState(() {
          if (teacherMode) {
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

    if (teacherMode) {
      if (hindiText.trim().isNotEmpty) {
        await translateTeacherSpeech();
      }
    } else {
      if (santaliText.trim().isNotEmpty) {
        await translateStudentSpeech();
      }
    }
  }

  Future<void> translateTeacherSpeech() async {
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
        await TtsService.speakSantali(
          santaliText,
        );
      }
    } catch (e) {
      showError(e);
    }
  }

  Future<void> translateStudentSpeech() async {
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
        await TtsService.speakHindi(
          hindiText,
        );
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

  void clearConversation() {
    setState(() {
      hindiText = '';
      santaliText = '';
    });

    TtsService.stop();
  }

  @override
  void dispose() {
    speech.stop();
    TtsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Classroom Mode',
        ),
        actions: [
          IconButton(
            onPressed: clearConversation,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTeacherCard(),

                    const SizedBox(height: 18),

                    const Icon(
                      Icons.swap_vert,
                      size: 32,
                    ),

                    const SizedBox(height: 18),

                    _buildStudentCard(),

                    const SizedBox(height: 25),

                    if (translating)
                      const Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8),
                          Text(
                            'Translating...',
                          ),
                        ],
                      ),

                    const SizedBox(height: 15),

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
                        width: 88,
                        height: 88,
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
                          size: 42,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      listening
                          ? teacherMode
                              ? 'Teacher speaking...'
                              : 'Student speaking...'
                          : teacherMode
                              ? 'Hold to speak Hindi'
                              : 'Hold to speak Santali',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 18),

                    OutlinedButton.icon(
                      onPressed: listening || translating
                          ? null
                          : () {
                              setState(() {
                                teacherMode =
                                    !teacherMode;
                              });
                            },
                      icon: const Icon(
                        Icons.swap_horiz,
                      ),
                      label: Text(
                        teacherMode
                            ? 'Student Turn'
                            : 'Teacher Turn',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(
            Icons.school,
            size: 45,
          ),
          const SizedBox(height: 6),
          const Text(
            'AI Classroom Bridge',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hindi ↔ Santali',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherCard() {
    return _conversationCard(
      icon: Icons.person,
      title: 'Teacher',
      language: 'Hindi',
      text: hindiText,
    );
  }

  Widget _buildStudentCard() {
    return _conversationCard(
      icon: Icons.school,
      title: 'Student',
      language: 'Santali',
      text: santaliText,
    );
  }

  Widget _conversationCard({
    required IconData icon,
    required String title,
    required String language,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(language),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            text.isEmpty
                ? 'Waiting...'
                : text,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),

          if (text.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  if (language == 'Hindi') {
                    TtsService.speakHindi(text);
                  } else {
                    TtsService.speakSantali(text);
                  }
                },
                icon: const Icon(
                  Icons.volume_up,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
