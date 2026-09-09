import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/voice_service.dart';
import '../services/tts_service.dart';
import 'screens/lesson/lesson_generator_screen.dart';
import 'screens/worksheet/worksheet_screen.dart';
import 'screens/flashcards/flashcard_screen.dart';

void main() {
  runApp(const TribalLinguaAI());
}

class TribalLinguaAI extends StatelessWidget {
  const TribalLinguaAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tribal Lingua AI',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
      ),
      home: const TeacherSetupScreen(),
    );
  }
}

class TeacherSetupScreen extends StatefulWidget {
  const TeacherSetupScreen({super.key});

  @override
  State<TeacherSetupScreen> createState() =>
      _TeacherSetupScreenState();
}

class _TeacherSetupScreenState
    extends State<TeacherSetupScreen> {

  String selectedLanguage = 'Santhali';
  String selectedClass = 'Class 2';
  String selectedSubject = 'Foundational Mathematics';
  String selectedLesson = 'Counting 1–10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TRIBAL LINGUA AI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Classroom Setup',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Prepare your mother-tongue learning session',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              _buildDropdown(
                title: 'Class',
                value: selectedClass,
                items: [
                  'Class 1',
                  'Class 2',
                  'Class 3',
                  'Class 4',
                  'Class 5',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedClass = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              _buildDropdown(
                title: 'Subject',
                value: selectedSubject,
                items: [
                  'Foundational Mathematics',
                  'Foundational Literacy',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              _buildDropdown(
                title: 'Lesson',
                value: selectedLesson,
                items: [
                  'Counting 1–10',
                  'Number Recognition',
                  'Basic Addition',
                  'Basic Words',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedLesson = value!;
                  });
                },
              ),

              const SizedBox(height: 25),

              const Text(
                'Mother Tongue',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _languageCard(
                      'Santhali',
                      selectedLanguage == 'Santhali',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _languageCard(
                      'Mundari',
                      selectedLanguage == 'Mundari',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _languageCard(
                      'Ho',
                      selectedLanguage == 'Ho',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassroomScreen(
                          language: selectedLanguage,
                          lesson: selectedLesson,
                          className: selectedClass,
                          subject: selectedSubject,
                        ),
                      ),
                    );
                  },

                  icon: const Icon(Icons.play_arrow),

                  label: const Text(
                    'START LESSON',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LessonGeneratorScreen(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.auto_awesome,
                  ),

                  label: const Text(
                    '✨ AI LESSON GENERATOR',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const WorksheetScreen(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.picture_as_pdf,
                  ),

                  label: const Text(
                    '📄 WORKSHEET GENERATOR',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 58,

                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const FlashcardScreen(),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.style,
                  ),

                  label: const Text(
                    '🧠 VISUAL FLASHCARDS',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green.withValues(alpha: 0.08),
                ),

                child: const Row(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      color: Colors.green,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Offline-ready lesson content',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          initialValue: value,

          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),

          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _languageCard(
    String language,
    bool selected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = language;
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 8,
        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),

          border: Border.all(
            color: selected
                ? Colors.green
                : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),

          color: selected
              ? Colors.green.withValues(alpha: 0.08)
              : Colors.white,
        ),

        child: Column(
          children: [
            Icon(
              Icons.translate,
              color: selected
                  ? Colors.green
                  : Colors.grey,
            ),

            const SizedBox(height: 8),

            Text(
              language,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassroomScreen extends StatefulWidget {

  final String language;
  final String lesson;
  final String className;
  final String subject;

  const ClassroomScreen({
    super.key,
    required this.language,
    required this.lesson,
    required this.className,
    required this.subject,
  });

  @override
  State<ClassroomScreen> createState() =>
      _ClassroomScreenState();
}


class _ClassroomScreenState
    extends State<ClassroomScreen> {

  final TextEditingController controller =
      TextEditingController(
    text: 'बच्चों, इन आमों को गिनो। कितने आम हैं?',
  );

  final VoiceService voiceService =
      VoiceService();
  final TtsService ttsService =
      TtsService();

  String translatedText = '';

  bool loading = false;

  int latency = 0;

  bool listening = false;

  String recognizedText = '';


  Future<void> translate() async {

    if (controller.text.trim().isEmpty) {
      return;
    }


    setState(() {
      loading = true;
      translatedText = '';
      latency = 0;
    });


    try {

      final result =
          await ApiService.translate(
        text: controller.text.trim(),
        targetLanguage: widget.language,
        className: widget.className,
        subject: widget.subject,
        lesson: widget.lesson,
      );


      setState(() {

        translatedText =
            result['translated_text'] ?? '';

        latency =
            result['latency_ms'] ?? 0;

        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });


      if (!mounted) return;


      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Translation error: $e',
          ),
        ),
      );
    }
  }


  Future<void> startVoiceTranslation() async {

    try {

      setState(() {
        listening = true;
        recognizedText = '';
        translatedText = '';
        latency = 0;
      });

      await voiceService.startListening(

        onListening: () {
          setState(() {
            listening = true;
          });
        },

        onResult: (text) {
          setState(() {
            recognizedText = text;
          });
        },

        onStopped: () async {
          setState(() {
            listening = false;
          });

          if (recognizedText.trim().isNotEmpty) {
            await translateRecognizedSpeech();
          }
        },
      );

    } catch (e) {

      setState(() {
        listening = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Microphone error: $e',
          ),
        ),
      );
    }
  }


  Future<void> translateRecognizedSpeech() async {

    if (recognizedText.trim().isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    final stopwatch = Stopwatch()..start();

    try {

      final result =
          await ApiService.translate(
        text: recognizedText,
        targetLanguage: widget.language,
        className: widget.className,
        subject: widget.subject,
        lesson: widget.lesson,
      );

      final aiText =
          result['translated_text'] ?? '';

      stopwatch.stop();

      setState(() {

        translatedText = aiText;

        latency =
            stopwatch.elapsedMilliseconds;

        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Translation error: $e',
          ),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Classroom Assistant',
        ),
      ),


      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                '${widget.className} • '
                '${widget.lesson}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 5),


              Text(
                '${widget.subject} • '
                '${widget.language}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),


              const SizedBox(height: 25),


              const Text(
                '👩‍🏫 Teacher — Hindi',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),


              const SizedBox(height: 10),


              TextField(
                controller: controller,

                maxLines: 3,

                decoration: InputDecoration(
                  hintText:
                      'Enter teacher sentence',

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
              ),


              const SizedBox(height: 15),


              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  onPressed:
                      loading ? null : translate,

                  icon: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.translate,
                        ),

                  label: Text(
                    loading
                        ? 'TRANSLATING...'
                        : 'TRANSLATE TO '
                          '${widget.language.toUpperCase()}',
                  ),
                ),
              ),


              const SizedBox(height: 25),


              SizedBox(
                width: double.infinity,
                height: 70,

                child: ElevatedButton.icon(

                  onPressed: listening
                      ? () async {
                          await voiceService
                              .stopListening();
                        }
                      : startVoiceTranslation,

                  icon: Icon(
                    listening
                        ? Icons.stop
                        : Icons.mic,
                    size: 30,
                  ),

                  label: Text(
                    listening
                        ? 'STOP LISTENING'
                        : 'SPEAK IN HINDI',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),


              if (recognizedText.isNotEmpty) ...[

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(16),

                    color: Colors.orange
                        .withValues(alpha: 0.08),
                  ),


                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      const Text(
                        '🎤 Recognized Hindi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        recognizedText,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],


              const SizedBox(height: 25),


              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(18),

                  color: Colors.green
                      .withValues(alpha: 0.08),
                ),


                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      '🗣 ${widget.language}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),


                    const SizedBox(height: 15),


                    Text(
                      translatedText.isEmpty
                          ? 'Translation will appear here...'
                          : translatedText,

                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),


                    if (translatedText.isNotEmpty) ...[

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,

                        child: OutlinedButton.icon(

                          onPressed: () async {

                            try {

                              await ttsService.speak(
                                text: translatedText,
                                language: 'sat-IN',
                              );

                            } catch (e) {

                              if (!mounted) return;

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Santhali TTS is not available '
                                    'on this device: $e',
                                  ),
                                ),
                              );
                            }
                          },

                          icon: const Icon(
                            Icons.volume_up,
                          ),

                          label: const Text(
                            'PLAY TRIBAL AUDIO',
                          ),
                        ),
                      ),
                    ],


                    if (latency > 0) ...[

                      const SizedBox(height: 15),

                      Text(
                        '⚡ AI latency: '
                        '${(latency / 1000).toStringAsFixed(2)} s',

                        style: TextStyle(
                          color: latency <= 3000
                              ? Colors.green
                              : Colors.red,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
