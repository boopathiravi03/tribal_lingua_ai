import 'package:flutter/material.dart';
import '../../services/demo_data_service.dart';
import '../../services/offline_storage_service.dart';
import '../../services/tts_service.dart';

class SavedFlashcardsScreen extends StatefulWidget {
  const SavedFlashcardsScreen({super.key});

  @override
  State<SavedFlashcardsScreen> createState() => _SavedFlashcardsScreenState();
}

class _SavedFlashcardsScreenState extends State<SavedFlashcardsScreen> {
  bool loading = true;
  List<Map<String, String>> cards = [];
  int currentIndex = 0;
  String title = 'Counting 1–10 Vocabulary';

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  Future<void> loadFlashcards() async {
    final data = await OfflineStorageService.getFlashcards();

    List<Map<String, String>> parsed = [];

    if (data != null) {
      if (data['lesson'] != null) {
        title = data['lesson'].toString();
      }

      final rawList = data['flashcards'] ?? data['cards'];
      if (rawList is List && rawList.isNotEmpty) {
        for (final item in rawList) {
          if (item is Map) {
            parsed.add({
              'word': (item['word'] ?? item['object'] ?? '').toString(),
              'hindi': (item['hindi'] ?? item['label_hindi'] ?? '').toString(),
              'santali': (item['santali'] ?? item['label_santali'] ?? item['target'] ?? '').toString(),
              'visual': (item['visual'] ?? item['visual_idea'] ?? item['visual_type'] ?? '').toString(),
              'sentence': (item['sentence'] ?? item['child_friendly_sentence'] ?? '').toString(),
            });
          }
        }
      }

      if (parsed.isEmpty && data['content'] is String) {
        parsed = _parseMarkdownFlashcards(data['content'].toString());
      }
    }

    if (parsed.isEmpty) {
      parsed = DemoDataService.flashcards;
    }

    if (!mounted) return;

    setState(() {
      cards = parsed;
      loading = false;
    });
  }

  List<Map<String, String>> _parseMarkdownFlashcards(String text) {
    final List<Map<String, String>> list = [];
    final blocks = text.split(RegExp(r'CARD\s+\d+|---'));

    for (final block in blocks) {
      if (block.trim().isEmpty) continue;

      String word = '';
      String hindi = '';
      String santali = '';
      String visual = '';
      String sentence = '';

      for (final rawLine in block.split('\n')) {
        final line = rawLine.replaceAll(RegExp(r'[\*\-\#]'), '').trim();
        final lower = line.toLowerCase();

        if (lower.startsWith('word:')) {
          word = line.substring(5).trim();
        } else if (lower.startsWith('meaning:') || lower.startsWith('hindi:')) {
          hindi = line.substring(line.indexOf(':') + 1).trim();
        } else if (lower.startsWith('santali:') || lower.startsWith('target:')) {
          santali = line.substring(line.indexOf(':') + 1).trim();
        } else if (lower.startsWith('visual idea:') || lower.startsWith('visual:')) {
          visual = line.substring(line.indexOf(':') + 1).trim();
        } else if (lower.startsWith('child-friendly sentence:') || lower.startsWith('sentence:')) {
          sentence = line.substring(line.indexOf(':') + 1).trim();
        }
      }

      if (word.isNotEmpty || hindi.isNotEmpty || santali.isNotEmpty) {
        list.add({
          'word': word.isNotEmpty ? word : 'Vocabulary',
          'hindi': hindi.isNotEmpty ? hindi : word,
          'santali': santali.isNotEmpty ? santali : 'ᱫᱟᱨᱮ',
          'visual': visual.isNotEmpty ? visual : word,
          'sentence': sentence,
        });
      }
    }

    return list;
  }

  void nextCard() {
    if (cards.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % cards.length;
    });
  }

  void previousCard() {
    if (cards.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex - 1 + cards.length) % cards.length;
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
        title: const Text('Offline Visual Flashcards'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
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
                      'Offline Mode • Saved Content Available',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF075E54),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: _buildFlashcardDeck(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcardDeck() {
    final card = cards[currentIndex];
    final word = card['word'] ?? '';
    final hindi = card['hindi'] ?? '';
    final santali = card['santali'] ?? '';
    final visual = card['visual'] ?? '';
    final sentence = card['sentence'] ?? '';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Card ${currentIndex + 1} of ${cards.length}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Santali / Ol Chiki',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        LinearProgressIndicator(
          value: (currentIndex + 1) / cards.length,
          backgroundColor: Colors.grey.shade200,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF087F73)),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity == null) return;
              if (details.primaryVelocity! < 0) {
                nextCard();
              } else {
                previousCard();
              }
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: const Color(0xFF087F73).withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _visualEmoji(word, visual),
                        style: const TextStyle(fontSize: 72),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        word.isNotEmpty ? word : 'Vocabulary Item',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 6),

                      if (hindi.isNotEmpty)
                        Text(
                          hindi,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF18302C),
                          ),
                        ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      Text(
                        santali.isNotEmpty ? santali : 'ᱫᱟᱨᱮ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF087F73),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Ol Chiki Script',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),

                      const SizedBox(height: 16),

                      IconButton(
                        iconSize: 42,
                        icon: const Icon(
                          Icons.volume_up_rounded,
                          color: Color(0xFF087F73),
                        ),
                        onPressed: () async {
                          await TtsService.speakSantali(santali);
                        },
                      ),

                      if (sentence.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F8F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '"$sentence"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF34504B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: previousCard,
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text('Previous'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: nextCard,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF087F73),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _visualEmoji(String word, String visual) {
    final combined = '$word $visual'.toLowerCase();

    if (combined.contains('tree') || combined.contains('पेड़') || combined.contains('ᱫᱟᱨᱮ')) return '🌳';
    if (combined.contains('water') || combined.contains('पानी') || combined.contains('ᱫᱟᱜ')) return '💧';
    if (combined.contains('sun') || combined.contains('सूरज') || combined.contains('ᱥᱤᱧ')) return '☀️';
    if (combined.contains('house') || combined.contains('घर') || combined.contains('ᱚᱲᱟᱜ')) return '🏠';
    if (combined.contains('book') || combined.contains('किताब') || combined.contains('ᱯᱩᱛᱷᱤ')) return '📖';
    if (combined.contains('flower') || combined.contains('फूल') || combined.contains('ᱵᱟᱦᱟ')) return '🌸';
    if (combined.contains('mango') || combined.contains('आम')) return '🥭';
    if (combined.contains('one') || combined.contains('1')) return '1️⃣';
    if (combined.contains('two') || combined.contains('2')) return '2️⃣';
    if (combined.contains('three') || combined.contains('3')) return '3️⃣';

    return '✨';
  }
}
