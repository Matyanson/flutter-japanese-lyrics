import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';


class PracticeHeader extends ConsumerWidget {
  final String songId;

  const PracticeHeader({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider(songId).notifier);

    // GestureDetector pro detekci horizontálního scrollování
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Pokud je posun doprava, jdeme na předchozí slovo
          print('previous word');
          controller.previousWord();
        } else if (details.primaryVelocity! < 0) {
          // Pokud je posun doleva, jdeme na další slovo
          print('next word');
          controller.nextWord();
        }
      },
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Celá věta
          Text(
            controller.currentLine,
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Aktuální slovo
          Text(
            controller.currentWord,
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}