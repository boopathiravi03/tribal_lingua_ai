import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/voice_service.dart';
import '../services/tts_service.dart';
import 'screens/lesson/lesson_generator_screen.dart';
import 'screens/worksheet/worksheet_screen.dart';
import 'screens/flashcards/flashcard_screen.dart';
import 'screens/classroom/classroom_mode_screen.dart';
import 'screens/offline/offline_content_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TtsService.initialize();

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
                'Teacher Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'AI-powered vernacular education for tribal classrooms',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Teaching Language: $selectedLanguage',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.green,
                        ),
                        SizedBox(width: 7),
                        Text('Online'),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _featureCard(
                    context,
                    icon: Icons.menu_book,
                    title: 'AI Lesson',
                    subtitle: 'Generate bilingual lessons',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LessonGeneratorScreen(),
                        ),
                      );
                    },
                  ),

                  _featureCard(
                    context,
                    icon: Icons.assignment,
                    title: 'Worksheet',
                    subtitle: 'Generate bilingual worksheets',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const WorksheetScreen(),
                        ),
                      );
                    },
                  ),

                  _featureCard(
                    context,
                    icon: Icons.style,
                    title: 'Flashcards',
                    subtitle: 'Create learning flashcards',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const FlashcardScreen(),
                        ),
                      );
                    },
                  ),

                  _featureCard(
                    context,
                    icon: Icons.record_voice_over,
                    title: 'Classroom Mode',
                    subtitle: 'Hindi ↔ Santali voice',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ClassroomModeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.offline_bolt,
                    size: 32,
                  ),
                  title: const Text(
                    'Offline Learning',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Access synchronized content without internet',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const OfflineContentScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

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

  Widget _featureCard(
     BuildContext context, {
     required IconData icon,
     required String title,
     required String subtitle,
     required VoidCallback onTap,
   }) {
     return Card(
       elevation: 2,
       child: InkWell(
         borderRadius: BorderRadius.circular(16),
         onTap: onTap,
         child: Padding(
           padding: const EdgeInsets.all(16),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(
                 icon,
                 size: 38,
               ),

               const SizedBox(height: 10),

               Text(
                 title,
                 textAlign: TextAlign.center,
                 style: const TextStyle(
                   fontSize: 17,
                   fontWeight: FontWeight.bold,
                 ),
               ),

               const SizedBox(height: 5),

               Text(
                 subtitle,
                 textAlign: TextAlign.center,
                 style: const TextStyle(
                   fontSize: 12,
                 ),
               ),
             ],
           ),
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

                              await TtsService.speakSantali(
                                translatedText,
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
