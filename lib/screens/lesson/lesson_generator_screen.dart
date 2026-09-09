import 'package:flutter/material.dart';

import '../../services/api_service.dart';


class LessonGeneratorScreen
    extends StatefulWidget {

  const LessonGeneratorScreen({
    super.key,
  });

  @override
  State<LessonGeneratorScreen> createState() =>
      _LessonGeneratorScreenState();
}


class _LessonGeneratorScreenState
    extends State<LessonGeneratorScreen> {

  String className = 'Class 2';

  String subject =
      'Foundational Mathematics';

  String lesson =
      'Counting 1–10';

  String language = 'Santali';


  bool loading = false;

  Map<String, dynamic>? result;


  Future<void> generate() async {

    setState(() {
      loading = true;
      result = null;
    });


    try {

      final data =
          await ApiService.generateLesson(

        className: className,

        subject: subject,

        lesson: lesson,

        targetLanguage: language,
      );


      setState(() {
        result = data;
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
            'Generation failed: $e',
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
          'AI Lesson Generator',
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              'Create a Mother-Tongue Lesson',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'AI generates curriculum-aligned '
              'bilingual classroom content.',
            ),

            const SizedBox(height: 25),

            _infoCard(
              'Class',
              className,
              Icons.school,
            ),

            _infoCard(
              'Subject',
              subject,
              Icons.menu_book,
            ),

            _infoCard(
              'Lesson',
              lesson,
              Icons.topic,
            ),

            _infoCard(
              'Target Language',
              language,
              Icons.translate,
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(

                onPressed:
                    loading ? null : generate,

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
                        Icons.auto_awesome,
                      ),

                label: Text(
                  loading
                      ? 'GENERATING...'
                      : 'GENERATE LESSON',
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (result != null)
              _buildLesson(),
          ],
        ),
      ),
    );
  }


  Widget _infoCard(
    String title,
    String value,
    IconData icon,
  ) {

    return Container(

      margin:
          const EdgeInsets.only(bottom: 10),

      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(15),

        border:
            Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(

        children: [

          Icon(icon),

          const SizedBox(width: 15),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildLesson() {

    final data =
        result!['learning_objective'];

    final teacher =
        result!['teacher_script'];

    final activity =
        result!['activity'];

    final assessment =
        result!['assessment'] as List;


    return Column(

      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        _section(
          '🎯 Learning Objective',
          data['hindi'],
          data['target'],
        ),

        _section(
          '👩‍🏫 Teacher Script',
          teacher['hindi'],
          teacher['target'],
        ),

        _section(
          '🎲 Classroom Activity',
          activity['instructions']
              ['hindi'],
          activity['instructions']
              ['target'],
        ),

        const SizedBox(height: 20),

        const Text(
          '📝 Assessment',
          style: TextStyle(
            fontSize: 20,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ...assessment.map(
          (item) => Card(

            child: Padding(

              padding:
                  const EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    item['hindi'],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    item['target'],
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _section(
    String title,
    String hindi,
    String target,
  ) {

    return Card(

      margin:
          const EdgeInsets.only(bottom: 15),

      child: Padding(

        padding:
            const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Hindi',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            Text(
              hindi,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const Divider(height: 25),

            const Text(
              'Santali',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            Text(
              target,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
