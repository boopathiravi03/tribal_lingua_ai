import 'package:flutter/material.dart';
import '../../services/demo_data_service.dart';
import '../../services/offline_storage_service.dart';
import '../../services/tts_service.dart';
import '../../services/worksheet_pdf_service.dart';

class SavedWorksheetScreen extends StatefulWidget {
  const SavedWorksheetScreen({super.key});

  @override
  State<SavedWorksheetScreen> createState() => _SavedWorksheetScreenState();
}

class _SavedWorksheetScreenState extends State<SavedWorksheetScreen> {
  Map<String, dynamic>? worksheet;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadWorksheet();
  }

  Future<void> loadWorksheet() async {
    final data = await OfflineStorageService.getWorksheet();

    Map<String, dynamic>? parsed;

    if (data != null) {
      if (data['questions'] is List && (data['questions'] as List).isNotEmpty) {
        parsed = data;
      } else if (data['content'] is String) {
        parsed = _parseTextWorksheet(data['content'].toString(), data);
      }
    }

    if (parsed == null || parsed['questions'] == null) {
      parsed = {
        'title': {'hindi': DemoDataService.worksheet['title'], 'target': 'ᱧᱩᱛᱩᱢ ᱯᱩᱭᱞᱩ ᱟᱹᱲᱟᱹ'},
        'grade': DemoDataService.worksheet['grade'],
        'subject': DemoDataService.worksheet['subject'],
        'learning_outcome': {
          'hindi': DemoDataService.worksheet['learning_outcome'],
          'target': 'ᱢᱩᱬᱩᱛ ᱟᱹᱲᱟᱹ ᱪᱤᱱᱦᱟᱹᱣ ᱟᱨ ᱵᱩᱡᱷᱟᱹᱣ᱾',
        },
        'questions': (DemoDataService.worksheet['questions'] as List<String>).asMap().entries.map((e) {
          return {
            'number': e.key + 1,
            'hindi': e.value,
            'target': _getSantaliQuestion(e.key),
          };
        }).toList(),
      };
    }

    if (!mounted) return;

    setState(() {
      worksheet = parsed;
      loading = false;
    });
  }

  static String _getSantaliQuestion(int index) {
    switch (index) {
      case 0:
        return 'ᱫᱟᱨᱮ ᱨᱮᱱᱟᱜ ᱪᱤᱛᱟᱹᱨ ᱜᱚᱞ ᱢᱮ।';
      case 1:
        return 'ᱥᱟᱹᱨᱤ ᱪᱤᱛᱟᱹᱨ ᱥᱟᱶ ᱟᱹᱲᱟᱹ ᱡᱚᱲᱟᱣ ᱢᱮ।';
      case 2:
        return 'ᱢᱟᱪᱮᱛ ᱫᱮᱠᱷᱟᱣ ᱟᱠᱟᱫ ᱡᱤᱱᱤᱥ ᱨᱮᱱᱟᱜ ᱧᱩᱛᱩᱢ ᱞᱟᱹᱭ ᱢᱮ।';
      case 3:
        return 'ᱟᱹᱲᱟᱹ ᱯᱩᱨᱟᱹᱣ ᱢᱮ: ᱯ _ ᱱ।';
      default:
        return 'ᱢᱤᱫ ᱫᱟᱨᱮ ᱟᱸᱠᱟᱣ ᱢᱮ ᱟᱨ ᱧᱩᱛᱩᱢ ᱚᱞ ᱢᱮ।';
    }
  }

  Map<String, dynamic> _parseTextWorksheet(String text, Map<String, dynamic> raw) {
    String title = raw['lesson']?.toString() ?? 'NIPUN Foundation Worksheet';
    String outcome = raw['learning_outcome']?.toString() ?? 'Recognize and understand basic words';

    final List<Map<String, dynamic>> questionsList = [];

    final lines = text.split('\n');
    int qIndex = 1;

    for (final line in lines) {
      final clean = line.replaceAll(RegExp(r'[\*\#]'), '').trim();
      if (clean.toLowerCase().startsWith('worksheet title:')) {
        title = clean.substring(16).trim();
      } else if (clean.toLowerCase().startsWith('learning outcome:')) {
        outcome = clean.substring(17).trim();
      } else if (clean.toLowerCase().startsWith('question')) {
        final colonIndex = clean.indexOf(':');
        final qText = colonIndex != -1 ? clean.substring(colonIndex + 1).trim() : clean;
        if (qText.isNotEmpty) {
          questionsList.add({
            'number': qIndex++,
            'hindi': qText,
            'target': ' Santali practice exercise for question.',
          });
        }
      }
    }

    if (questionsList.isEmpty) {
      questionsList.addAll([
        {'number': 1, 'hindi': 'सब बच्चे पेड़ का चित्र बनाओ।', 'target': 'ᱡᱚᱛᱚ ᱦᱚᱲ ᱫᱟᱨᱮ ᱨᱮᱱᱟᱜ ᱪᱤᱛᱟᱹᱨ ᱵᱮᱱᱟᱣ ᱢᱮ।'},
        {'number': 2, 'hindi': 'सही शब्द चुनकर खाली स्थान भरो।', 'target': 'ᱥᱟᱹᱨᱤ ᱟᱹᱲᱟᱹ ᱪᱤᱱᱦᱟᱹᱣ ᱠᱟᱛᱮ ᱚᱞ ᱢᱮ।'},
        {'number': 3, 'hindi': 'चित्र देखकर नाम बोलो।', 'target': 'ᱪᱤᱛᱟᱹᱨ ᱧᱮᱞ ᱠᱟᱛᱮ ᱧᱩᱛᱩᱢ ᱞᱟᱹᱭ ᱢᱮ।'},
      ]);
    }

    return {
      'title': {'hindi': title, 'target': title},
      'grade': raw['grade']?.toString() ?? 'Grade 1',
      'subject': raw['subject']?.toString() ?? 'Foundational Literacy',
      'learning_outcome': {
        'hindi': outcome,
        'target': ' foundational skills',
      },
      'questions': questionsList,
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

    if (worksheet == null) {
      return const Scaffold(
        body: Center(
          child: Text('No saved worksheet available.'),
        ),
      );
    }

    final titleObj = worksheet!['title'];
    final titleText = titleObj is Map ? (titleObj['hindi'] ?? '') : titleObj.toString();
    final grade = worksheet!['grade']?.toString() ?? 'Grade 1';
    final subject = worksheet!['subject']?.toString() ?? 'Foundational Literacy';
    final outcomeObj = worksheet!['learning_outcome'];
    final outcomeHindi = outcomeObj is Map ? (outcomeObj['hindi'] ?? '') : outcomeObj.toString();
    final outcomeTarget = outcomeObj is Map ? (outcomeObj['target'] ?? '') : '';
    final questions = (worksheet!['questions'] as List<dynamic>? ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Worksheet'),
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
                    'Offline Mode • Formatted Worksheet',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF075E54),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Grade', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(grade, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Subject', style: TextStyle(fontSize: 11, color: Colors.grey)),
                        Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              titleText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF18302C),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF087F73).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.flag_rounded, color: Color(0xFF087F73), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'NIPUN Bharat Learning Outcome',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF075E54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    outcomeHindi,
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (outcomeTarget.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      outcomeTarget,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF087F73),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Questions & Activities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF18302C),
              ),
            ),

            const SizedBox(height: 12),

            ...questions.map((q) {
              final number = q['number'] ?? 1;
              final hindiQ = q['hindi'] ?? '';
              final targetQ = q['target'] ?? '';

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Colors.black12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF087F73),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Q$number',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              hindiQ,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (targetQ.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Santali / Ol Chiki',
                                      style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      targetQ,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF087F73),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF087F73)),
                                onPressed: () {
                                  TtsService.speakSantali(targetQ);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),

                      const Row(
                        children: [
                          Text('Answer: ', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          Expanded(
                            child: Text(
                              '____________________________________',
                              style: TextStyle(color: Colors.black26),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await WorksheetPdfService.generateAndPrint(worksheet!);
                },
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text(
                  'EXPORT / PRINT WORKSHEET PDF',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087F73),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
