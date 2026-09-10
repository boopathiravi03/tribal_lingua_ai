import 'package:flutter/material.dart';

import '../../services/offline_storage_service.dart';

import 'saved_worksheet_screen.dart';

import 'saved_flashcards_screen.dart';

class OfflineContentScreen extends StatefulWidget {
  const OfflineContentScreen({super.key});

  @override
  State<OfflineContentScreen> createState() =>
      _OfflineContentScreenState();
}

class _OfflineContentScreenState
    extends State<OfflineContentScreen> {
  bool hasContent = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkOfflineContent();
  }

  Future<void> checkOfflineContent() async {
    final result =
        await OfflineStorageService.hasOfflineContent();

    if (!mounted) return;

    setState(() {
      hasContent = result;
      loading = false;
    });
  }

  Future<void> clearContent() async {
    await OfflineStorageService.clearOfflineContent();

    if (!mounted) return;

    setState(() {
      hasContent = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Offline content cleared.',
        ),
      ),
    );
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Offline Content',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.offline_bolt,
              size: 70,
            ),

            const SizedBox(height: 15),

            const Text(
              'Offline Learning Mode',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              hasContent
                  ? 'Learning content is available offline.'
                  : 'No offline content downloaded yet.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            _contentCard(
              Icons.menu_book,
              'Lessons',
              'Access saved classroom lessons',
            ),

            _contentCard(
              Icons.assignment,
              'Worksheets',
              'Access saved bilingual worksheets',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SavedWorksheetScreen(),
                  ),
                );
              },
            ),

            _contentCard(
              Icons.style,
              'Flashcards',
              'Access saved visual flashcards',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SavedFlashcardsScreen(),
                  ),
                );
              },
            ),

            const Spacer(),

            if (hasContent)
              OutlinedButton.icon(
                onPressed: clearContent,
                icon: const Icon(
                  Icons.delete_outline,
                ),
                label: const Text(
                  'Clear Offline Content',
                ),
              ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.wifi_off,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'These learning resources remain '
                      'available when internet is unavailable.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentCard(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
