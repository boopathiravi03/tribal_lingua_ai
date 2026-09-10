import 'package:flutter/material.dart';

import '../../services/offline_storage_service.dart';

class SavedFlashcardsScreen extends StatefulWidget {
  const SavedFlashcardsScreen({super.key});

  @override
  State<SavedFlashcardsScreen> createState() =>
      _SavedFlashcardsScreenState();
}

class _SavedFlashcardsScreenState
    extends State<SavedFlashcardsScreen> {
  Map<String, dynamic>? flashcards;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    final data =
        await OfflineStorageService.getFlashcards();

    if (!mounted) return;

    setState(() {
      flashcards = data;
      loading = false;
    });
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
          'Offline Flashcards',
        ),
      ),
      body: flashcards == null
          ? const Center(
              child: Text(
                'No saved flashcards available.',
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.offline_bolt,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Available Offline',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildCards(flashcards!),
                ],
              ),
            ),
    );
  }

  Widget _buildCards(
    Map<String, dynamic> data,
  ) {
    final items = _extractList(data);

    if (items.isEmpty) {
      return _genericDisplay(data);
    }

    return Column(
      children: List.generate(
        items.length,
        (index) {
          final item = items[index];

          return Card(
            margin: const EdgeInsets.only(
              bottom: 15,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: _flashcardContent(
                  item,
                  index + 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<dynamic> _extractList(
    Map<String, dynamic> data,
  ) {
    for (final value in data.values) {
      if (value is List) {
        return value;
      }
    }

    return [];
  }

  Widget _flashcardContent(
    dynamic item,
    int number,
  ) {
    if (item is Map) {
      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Flashcard $number',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...item.entries.map(
            (entry) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 8,
              ),
              child: Text(
                '${_formatTitle(entry.key)}: '
                '${entry.value}',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Text(
      item.toString(),
      style: const TextStyle(
        fontSize: 18,
      ),
    );
  }

  Widget _genericDisplay(
    Map<String, dynamic> data,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: data.entries.map(
        (entry) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 18,
            ),
            child: Text(
              '${_formatTitle(entry.key)}\n'
              '${entry.value}',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  String _formatTitle(String value) {
    return value
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                '${word.substring(1)}',
        )
        .join(' ');
  }
}
