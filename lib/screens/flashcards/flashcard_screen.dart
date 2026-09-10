import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/tts_service.dart';
import '../../services/offline_storage_service.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  bool loading = false;
  List<dynamic> cards = [];
  int currentIndex = 0;

  Future<void> generateFlashcards() async {
    setState(() {
      loading = true;
      cards = [];
      currentIndex = 0;
    });

    try {
      final result = await ApiService.generateFlashcards(
        className: 'Class 2',
        subject: 'Foundational Mathematics',
        lesson: 'Counting 1-10',
        targetLanguage: 'Santali',
      );

      if (!mounted) return;

      setState(() {
        cards = (result['flashcards'] ??
                result['cards'] ??
                []) as List<dynamic>;
        loading = false;
      });

      await OfflineStorageService.saveFlashcards(result);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Flashcard error: $e'),
        ),
      );
    }
  }

  void nextCard() {
    if (cards.isEmpty) return;

    setState(() {
      currentIndex =
          (currentIndex + 1) % cards.length;
    });
  }

  void previousCard() {
    if (cards.isEmpty) return;

    setState(() {
      currentIndex =
          (currentIndex - 1 + cards.length) %
              cards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Flashcards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.style,
              size: 55,
            ),

            const SizedBox(height: 10),

            const Text(
              'AI Visual Flashcards',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Class 2 • Counting 1-10 • Santali',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                    loading ? null : generateFlashcards,
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
                      : 'GENERATE FLASHCARDS',
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (cards.isNotEmpty)
              Expanded(
                child: _buildFlashcardArea(),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'Generate flashcards to begin.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardArea() {
    final card = cards[currentIndex];

    final hindi =
        card['label_hindi']?.toString() ??
        card['hindi']?.toString() ??
        '';

    final santali =
        card['label_santali']?.toString() ??
        card['target']?.toString() ??
        '';

    final visualType =
        card['visual_type']?.toString() ?? 'object';

    final object =
        card['object']?.toString() ?? '';

    final count =
        card['count']?.toString() ?? '';

    return Column(
      children: [
        Text(
          'Card ${currentIndex + 1} / ${cards.length}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) {
                return;
              }

              if (details.primaryVelocity! < 0) {
                nextCard();
              } else {
                previousCard();
              }
            },
            child: Card(
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      _visualEmoji(object),
                      style: const TextStyle(
                        fontSize: 80,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      count.isNotEmpty
                          ? count
                          : visualType,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      hindi,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Divider(),

                    const SizedBox(height: 15),

                    Text(
                      santali,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Santali • Ol Chiki',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 25),

                    IconButton(
                      iconSize: 42,
                      icon: const Icon(
                        Icons.volume_up,
                      ),
                      onPressed: () async {
                        final available =
                            await TtsService.speakSantali(
                          santali,
                        );

                        if (!mounted) return;

                        if (!available) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Native Santali TTS is not available on this device. '
                                'Audio fallback used for prototype testing.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previousCard,
                icon: const Icon(
                  Icons.arrow_back,
                ),
                label: const Text('Previous'),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: nextCard,
                icon: const Icon(
                  Icons.arrow_forward,
                ),
                label: const Text('Next'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        const Text(
          'Swipe left or right to change cards',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _visualEmoji(String object) {
    final value = object.toLowerCase();

    if (value.contains('mango')) {
      return '🥭';
    }

    if (value.contains('leaf')) {
      return '🍃';
    }

    if (value.contains('flower')) {
      return '🌸';
    }

    if (value.contains('stone')) {
      return '🪨';
    }

    if (value.contains('grain')) {
      return '🌾';
    }

    if (value.contains('apple')) {
      return '🍎';
    }

    return '🔢';
  }
}
