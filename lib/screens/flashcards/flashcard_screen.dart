import 'package:flutter/material.dart';

import '../../services/api_service.dart';


class FlashcardScreen
    extends StatefulWidget {

  const FlashcardScreen({
    super.key,
  });

  @override
  State<FlashcardScreen> createState() =>
      _FlashcardScreenState();
}


class _FlashcardScreenState
    extends State<FlashcardScreen> {

  bool loading = false;

  List<dynamic> cards = [];

  int currentCard = 0;


  Future<void> generate() async {

    setState(() {
      loading = true;
      cards = [];
      currentCard = 0;
    });


    try {

      final result =
          await ApiService.generateFlashcards(

        className: 'Class 2',

        subject:
            'Foundational Mathematics',

        lesson: 'Counting 1-10',

        targetLanguage: 'Santali',
      );


      setState(() {

        cards =
            result['cards'] as List;

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
          'Visual Flashcards',
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const Text(
              '🧠 AI Visual Flashcards',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Bilingual learning material '
              'for mother-tongue education.',
            ),

            const SizedBox(height: 25),

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
                      : 'GENERATE FLASHCARDS',
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (cards.isNotEmpty)
              Expanded(
                child:
                    _buildCard(),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildCard() {

    final card =
        cards[currentCard];


    final count =
        card['count'] as int;


    return Column(

      children: [

        Text(
          'Card ${currentCard + 1}'
          ' / ${cards.length}',
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 12),


        Expanded(

          child: Card(

            elevation: 6,

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                25,
              ),
            ),

            child: Padding(

              padding:
                  const EdgeInsets.all(25),

              child: Column(

                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Text(
                    card['concept'],
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildVisual(
                    card['object'],
                    count,
                  ),

                  const SizedBox(height: 30),

                  Text(
                    card['label_hindi'],
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Divider(),

                  const SizedBox(height: 12),

                  Text(
                    card['label_santali'],
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        Row(

          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

          children: [

            OutlinedButton.icon(

              onPressed:
                  currentCard > 0
                      ? () {

                          setState(() {
                            currentCard--;
                          });

                        }
                      : null,

              icon: const Icon(
                Icons.arrow_back,
              ),

              label:
                  const Text('Previous'),
            ),


            OutlinedButton.icon(

              onPressed:
                  currentCard <
                          cards.length - 1
                      ? () {

                          setState(() {
                            currentCard++;
                          });

                        }
                      : null,

              icon: const Icon(
                Icons.arrow_forward,
              ),

              label:
                  const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildVisual(
    String object,
    int count,
  ) {

    String emoji = '●';


    switch (object.toLowerCase()) {

      case 'mango':
      case 'mangoes':
        emoji = '🥭';
        break;

      case 'leaf':
      case 'leaves':
        emoji = '🍃';
        break;

      case 'flower':
      case 'flowers':
        emoji = '🌸';
        break;

      case 'stone':
      case 'stones':
        emoji = '🪨';
        break;

      case 'pencil':
      case 'pencils':
        emoji = '✏️';
        break;
    }


    return Wrap(

      alignment:
          WrapAlignment.center,

      spacing: 10,

      runSpacing: 10,

      children: List.generate(
        count,
        (_) => Text(
          emoji,
          style: const TextStyle(
            fontSize: 45,
          ),
        ),
      ),
    );
  }
}
