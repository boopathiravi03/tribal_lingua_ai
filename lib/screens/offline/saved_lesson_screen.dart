import 'package:flutter/material.dart';
import '../../services/demo_data_service.dart';
import '../../services/offline_storage_service.dart';
import '../../services/tts_service.dart';

class SavedLessonScreen extends StatefulWidget {
  const SavedLessonScreen({super.key});

  @override
  State<SavedLessonScreen> createState() => _SavedLessonScreenState();
}

class _SavedLessonScreenState extends State<SavedLessonScreen> {
  Map<String, dynamic>? lessonData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLesson();
  }

  Future<void> loadLesson() async {
    final data = await OfflineStorageService.getLesson();

    Map<String, dynamic>? parsed;

    if (data != null) {
      if (data['learning_objective'] != null) {
        parsed = data;
      } else if (data['content'] is String) {
        parsed = _parseTextLesson(data['content'].toString(), data);
      }
    }

    parsed ??= {
        'title': DemoDataService.lesson['title'],
        'class_name': DemoDataService.lesson['class'],
        'subject': DemoDataService.lesson['subject'],
        'target_language': 'Santali',
        'learning_objective': {
          'hindi': DemoDataService.lesson['objective'],
          'target': 'ᱜᱤᱫᱽᱨᱟᱹ ᱠᱚ ᱟᱠᱚᱣᱟᱜ ᱟᱭᱳ ᱟᱲᱟᱝ ᱛᱮ ᱡᱤᱱᱤᱥ ᱨᱮᱱᱟᱜ ᱧᱩᱛᱩᱢ ᱠᱚ ᱪᱮᱫᱚᱜᱼᱟ᱾',
        },
        'teacher_script': {
          'hindi': DemoDataService.lesson['introduction'],
          'target': 'ᱢᱟᱪᱮᱛ ᱫᱟᱨᱮ ᱨᱮᱱᱟᱜ ᱪᱤᱛᱟᱹᱨ ᱩᱫᱩᱜ ᱠᱟᱛᱮ ᱪᱮᱫ ᱠᱚ ᱧᱮᱞᱮᱫᱼᱟ ᱠᱩᱞᱤᱭᱟᱠᱚᱣᱟ᱾',
        },
        'activity': {
          'hindi': DemoDataService.lesson['activity'],
          'target': 'ᱜᱤᱫᱽᱨᱟᱹ ᱠᱚ ᱟᱥᱲᱟ ᱥᱩᱨ ᱨᱮᱱᱟᱜ ᱫᱟᱨᱮ ᱪᱤᱱᱦᱟᱹᱣ ᱠᱟᱛᱮ ᱧᱩᱛᱩᱢ ᱞᱟᱹᱭ ᱢᱮ᱾',
        },
        'assessment': [
          {
            'hindi': DemoDataService.lesson['assessment'],
            'target': 'ᱡᱚᱛᱚ ᱜᱤᱫᱽᱨᱟᱹ ᱢᱤᱫᱴᱟᱝ ᱫᱟᱨᱮ ᱵᱟᱵᱚᱛ ᱛᱮ ᱢᱤᱫ ᱥᱟᱹᱨᱤ ᱠᱟᱛᱷᱟ ᱞᱟᱹᱭ ᱢᱮ᱾',
          }
        ],
        'teacher_tip': DemoDataService.lesson['teacher_tip'],
      };

    if (!mounted) return;

    setState(() {
      lessonData = parsed;
      loading = false;
    });
  }

  Map<String, dynamic> _parseTextLesson(String text, Map<String, dynamic> raw) {
    String title = raw['lesson']?.toString() ?? 'Primary Classroom Lesson';
    String objective = '';
    String intro = '';
    String activity = '';
    String assessment = '';
    String tip = '';
    String motherTongue = '';

    final sections = text.split(RegExp(r'\n(?=[A-Z\s]{4,}:)'));

    for (final sec in sections) {
      final trimmed = sec.trim();
      final lower = trimmed.toLowerCase();

      if (lower.startsWith('title:')) {
        title = trimmed.substring(6).trim();
      } else if (lower.startsWith('learning objective:')) {
        objective = trimmed.substring(19).trim();
      } else if (lower.startsWith('teacher introduction:') || lower.startsWith('teacher script:')) {
        intro = trimmed.substring(trimmed.indexOf(':') + 1).trim();
      } else if (lower.startsWith('activity:')) {
        activity = trimmed.substring(9).trim();
      } else if (lower.startsWith('assessment:')) {
        assessment = trimmed.substring(11).trim();
      } else if (lower.startsWith('teacher tip:')) {
        tip = trimmed.substring(12).trim();
      } else if (lower.startsWith('mother tongue support:')) {
        motherTongue = trimmed.substring(22).trim();
      }
    }

    return {
      'title': title,
      'class_name': raw['class_name']?.toString() ?? 'Grade 1',
      'subject': raw['subject']?.toString() ?? 'Foundational Literacy',
      'target_language': raw['target_language']?.toString() ?? 'Santali',
      'learning_objective': {
        'hindi': objective.isNotEmpty ? objective : 'Children identify objects in mother tongue.',
        'target': 'ᱜᱤᱫᱽᱨᱟᱹ ᱠᱚ ᱟᱠᱚᱣᱟᱜ ᱟᱭᱳ ᱟᱲᱟᱝ ᱛᱮ ᱪᱮᱫᱚᱜᱼᱟ᱾',
      },
      'teacher_script': {
        'hindi': intro.isNotEmpty ? intro : 'Show visual aids and introduce simple vocabulary.',
        'target': 'ᱢᱟᱪᱮᱛ ᱪᱤᱛᱟᱹᱨ ᱩᱫᱩᱜ ᱠᱟᱛᱮ ᱪᱮᱫᱚᱜ ᱮᱦᱚᱵ ᱢᱮ᱾',
      },
      'activity': {
        'hindi': activity.isNotEmpty ? activity : 'Interactive group identification activity.',
        'target': 'ᱜᱤᱫᱽᱨᱟᱹ ᱠᱚ ᱥᱟᱶ ᱪᱤᱱᱦᱟᱹᱣ ᱠᱟᱹᱢᱤ ᱦᱚᱨᱟ᱾',
      },
      'assessment': [
        {
          'hindi': assessment.isNotEmpty ? assessment : 'Ask each child to name one object.',
          'target': 'ᱡᱚᱛᱚ ᱜᱤᱫᱽᱨᱟᱹ ᱢᱤᱫᱴᱟᱝ ᱧᱩᱛᱩᱢ ᱞᱟᱹᱭ ᱢᱮ᱾',
        }
      ],
      'teacher_tip': tip.isNotEmpty ? tip : 'Use real objects and gestures in classroom.',
      'mother_tongue': motherTongue,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (lessonData == null) {
      return const Scaffold(
        body: Center(
          child: Text('No saved lesson available.'),
        ),
      );
    }

    final title = lessonData!['title']?.toString() ?? 'Bilingual Lesson';
    final className = lessonData!['class_name']?.toString() ?? 'Grade 1';
    final subject = lessonData!['subject']?.toString() ?? 'Foundational Literacy';
    final targetLang = lessonData!['target_language']?.toString() ?? 'Santali';

    final obj = lessonData!['learning_objective'];
    final script = lessonData!['teacher_script'];
    final act = lessonData!['activity'];
    final assessList = (lessonData!['assessment'] as List<dynamic>? ?? []);
    final tip = lessonData!['teacher_tip']?.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline AI Lesson'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F3EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.offline_pin_rounded, color: Color(0xFF087F73), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode • Saved Lesson Plan',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF075E54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF18302C),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _chip(className, Colors.blue.shade100, Colors.blue.shade900),
                const SizedBox(width: 8),
                _chip(subject, Colors.teal.shade100, Colors.teal.shade900),
                const SizedBox(width: 8),
                _chip(targetLang, Colors.amber.shade100, Colors.amber.shade900),
              ],
            ),

            const SizedBox(height: 22),

            if (obj != null) _buildSection('🎯 Learning Objective', obj),

            if (script != null) _buildSection('👩‍🏫 Teacher Introduction', script),

            if (act != null) _buildSection('🎲 Classroom Activity', act),

            if (assessList.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text(
                '📝 Assessment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF18302C),
                ),
              ),
              const SizedBox(height: 10),
              ...assessList.map((item) {
                final h = item is Map ? (item['hindi'] ?? '') : item.toString();
                final t = item is Map ? (item['target'] ?? '') : '';

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Colors.black12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h, style: const TextStyle(fontSize: 15)),
                        if (t.toString().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  t.toString(),
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF087F73),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF087F73)),
                                onPressed: () {
                                  TtsService.speakSantali(t.toString());
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ],

            if (tip != null && tip.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4D6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6C96A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: Color(0xFF8A6800)),
                        SizedBox(width: 8),
                        Text(
                          'Teacher Tip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6F5700),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tip,
                      style: const TextStyle(color: Color(0xFF524100), height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildSection(String sectionTitle, dynamic content) {
    final hindi = content is Map ? (content['hindi'] ?? '') : content.toString();
    final target = content is Map ? (content['target'] ?? '') : '';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18302C),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Hindi', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(hindi, style: const TextStyle(fontSize: 15)),
            if (target.toString().isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),
              const Text('Santali / Ol Chiki', style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      target.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF087F73),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF087F73)),
                    onPressed: () {
                      TtsService.speakSantali(target.toString());
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
