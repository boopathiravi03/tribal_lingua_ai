import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class WorksheetPdfService {
  static Future<void> generateAndPrint(
    Map<String, dynamic> worksheet,
  ) async {
    final regularFontData = await rootBundle.load(
      'assets/fonts/NotoSansOlChiki-Regular.ttf',
    );

    final regularFont = pw.Font.ttf(
      regularFontData,
    );

    final pdf = pw.Document();

    final questions =
        (worksheet['questions'] as List<dynamic>?) ?? [];

    final title = worksheet['title']?['hindi']?.toString() ??
        'Bilingual Worksheet';

    final grade = worksheet['grade']?.toString() ?? '';

    final subject = worksheet['subject']?.toString() ?? '';

    final learningOutcomeHindi =
        worksheet['learning_outcome']?['hindi']?.toString() ?? '';

    final learningOutcomeTarget =
        worksheet['learning_outcome']?['target']?.toString() ?? '';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'TRIBAL LINGUA AI',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 6),

            pw.Center(
              child: pw.Text(
                'Bilingual Learning Worksheet',
                style: const pw.TextStyle(
                  fontSize: 15,
                ),
              ),
            ),

            pw.SizedBox(height: 18),

            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 15),

            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    grade.isNotEmpty
                        ? 'Grade: $grade'
                        : 'Class: Class 2',
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    subject.isNotEmpty
                        ? 'Subject: $subject'
                        : 'Subject: Foundational Mathematics',
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 8),

            pw.Text('Lesson: Counting 1-10'),

            pw.SizedBox(height: 15),

            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'Name: __________________________',
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    'Date: ______________',
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Learning Outcome',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(learningOutcomeHindi),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    learningOutcomeTarget,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'Questions',
              style: pw.TextStyle(
                fontSize: 17,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            ...questions.map(
              (question) {
                final number =
                    question['number']?.toString() ?? '';

                final hindi =
                    question['hindi']?.toString() ?? '';

                final target =
                    question['target']?.toString() ?? '';

                return pw.Container(
                  margin: const pw.EdgeInsets.only(
                    bottom: 15,
                  ),
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    crossAxisAlignment:
                        pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        '$number. $hindi',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),

                      pw.SizedBox(height: 7),

                      pw.Text(
                        target,
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 16,
                        ),
                      ),

                      pw.SizedBox(height: 12),

                      pw.Text(
                        'Answer: ______________________________',
                      ),
                    ],
                  ),
                );
              },
            ),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text(
                'Generated by Tribal Lingua AI',
                style: const pw.TextStyle(
                  fontSize: 9,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        return pdf.save();
      },
    );
  }
}
