import 'package:flutter/material.dart';

import '../../services/api_service.dart';


class WorksheetScreen extends StatefulWidget {

  const WorksheetScreen({
    super.key,
  });

  @override
  State<WorksheetScreen> createState() =>
      _WorksheetScreenState();
}


class _WorksheetScreenState
    extends State<WorksheetScreen> {

  bool loading = false;

  Map<String, dynamic>? worksheet;


  Future<void> generateWorksheet() async {

    setState(() {
      loading = true;
      worksheet = null;
    });

    try {

      final result =
          await ApiService.generateWorksheet(
        className: 'Class 2',
        subject:
            'Foundational Mathematics',
        lesson: 'Counting 1-10',
        targetLanguage: 'Santali',
      );

      setState(() {
        worksheet = result;
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
            'Error: $e',
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
          'Worksheet Generator',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const Text(
              '📄 Bilingual Worksheet',
              style: TextStyle(
                fontSize: 25,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Generate Hindi + Santali '
              'learning material.',
            ),

            const SizedBox(height: 25),

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
                      : 'GENERATE WORKSHEET',
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (worksheet != null)
              Expanded(
                child:
                    _buildPreview(),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildPreview() {

    final questions =
        worksheet!['questions'] as List;


    return ListView(

      children: [

        Text(
          worksheet!['title']['hindi'],
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          worksheet![
              'learning_outcome'
          ]['hindi'],
        ),

        const SizedBox(height: 20),

        ...questions.map(
          (q) => Card(

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
                    '${q['number']}. '
                    '${q['hindi']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    q['target'],
                    style: const TextStyle(
                      fontSize: 17,
                    ),
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
          ),
        ),

        const SizedBox(height: 15),

        SizedBox(
          height: 55,

          child: OutlinedButton.icon(

            onPressed: () {
              // PDF download/preview
              // will be connected next.
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
