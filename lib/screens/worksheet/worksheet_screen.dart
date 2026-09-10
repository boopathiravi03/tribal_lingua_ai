import 'package:flutter/material.dart';

import '../../services/api_service.dart';

import '../../services/worksheet_pdf_service.dart';

import '../../services/tts_service.dart';

import '../../services/offline_storage_service.dart';

class WorksheetScreen extends StatefulWidget {
  const WorksheetScreen({super.key});

  @override
  State<WorksheetScreen> createState() =>
      _WorksheetScreenState();
}

class _WorksheetScreenState extends State<WorksheetScreen> {
  bool loading = false;

  Map<String, dynamic>? worksheet;

  String selectedGrade = 'Grade 1';
  String selectedSubject = 'Foundational Numeracy';
  String selectedOutcome = 'Recognises and counts numbers';

  Future<void> generateWorksheet() async {
    setState(() {
      loading = true;
      worksheet = null;
    });

    try {
      final result =
          await ApiService.generateWorksheet(
        className: 'Class 2',
        subject: selectedSubject,
        lesson: 'Counting 1-10',
        targetLanguage: 'Santali',
        grade: selectedGrade,
        learningOutcome: selectedOutcome,
      );

      if (!mounted) return;

      setState(() {
        worksheet = result;
        loading = false;
      });

      await OfflineStorageService.saveWorksheet(result);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Worksheet Generator',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 60,
            ),

            const SizedBox(height: 12),

            const Text(
              'AI Bilingual Worksheet',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Hindi + Santali',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            DropdownButtonFormField<String>(
              value: selectedGrade,
              decoration: const InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Grade 1',
                  child: Text('Grade 1'),
                ),
                DropdownMenuItem(
                  value: 'Grade 2',
                  child: Text('Grade 2'),
                ),
                DropdownMenuItem(
                  value: 'Grade 3',
                  child: Text('Grade 3'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedGrade = value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedSubject,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Foundational Numeracy',
                  child: Text(
                    'Foundational Numeracy',
                  ),
                ),
                DropdownMenuItem(
                  value: 'Foundational Literacy',
                  child: Text(
                    'Foundational Literacy',
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSubject = value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedOutcome,
              decoration: const InputDecoration(
                labelText: 'Learning Outcome',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Recognises and counts numbers',
                  child: Text(
                    'Recognises and counts numbers',
                  ),
                ),
                DropdownMenuItem(
                  value: 'Identifies basic letters and sounds',
                  child: Text(
                    'Identifies basic letters and sounds',
                  ),
                ),
                DropdownMenuItem(
                  value: 'Understands simple words',
                  child: Text(
                    'Understands simple words',
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedOutcome = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    loading
                        ? null
                        : generateWorksheet,
                icon: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
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
                      : 'GENERATE WORKSHEET',
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (worksheet != null)
              Expanded(
                child: buildWorksheet(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildWorksheet() {
    final questions =
        worksheet!['questions'] as List<dynamic>;

    final grade = worksheet!['grade']?.toString() ??
        selectedGrade;

    final subject = worksheet!['subject']?.toString() ??
        selectedSubject;

    return ListView(
      children: [
        const Divider(),

        Row(
          children: [
            Expanded(
              child: Text(
                'Grade: $grade',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Subject: $subject',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Text(
          'Learning Outcome: $selectedOutcome',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 15),

        Text(
          worksheet!['title']['hindi']
              .toString(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                '🎯 Learning Outcome',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                worksheet![
                    'learning_outcome']['hindi'],
              ),

              const SizedBox(height: 8),

              Text(
                worksheet![
                    'learning_outcome']['target'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        const Text(
          'Questions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        ...questions.map(
          (question) {
            return Card(
              margin:
                  const EdgeInsets.only(
                bottom: 12,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${question['number']}. '
                      '${question['hindi']}',
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Santali / Ol Chiki',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            question['target']
                                .toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.volume_up,
                          ),
                          onPressed: () {
                            TtsService.speakSantali(
                              question['target']
                                  .toString(),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 10),

                    const Text(
                      'Answer: '
                      '____________________',
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 55,

          child: OutlinedButton.icon(

            onPressed: () async {
              if (worksheet == null) return;

              await WorksheetPdfService.generateAndPrint(
                worksheet!,
              );
            },

            icon: const Icon(
              Icons.picture_as_pdf,
            ),

            label: const Text(
              'EXPORT PDF',
            ),
          ),
        ),
      ],
    );
  }
}
