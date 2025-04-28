import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeModeSelector extends ConsumerWidget {
  final String songId;

  const PracticeModeSelector({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider(songId).notifier);

    return BottomNavigationBar(
      currentIndex: controller.mode.index,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 3) {
          controller.previousWord();
        }
        if (index == 4) {
          controller.nextWord();
        } else {
          controller.changeMode(PracticeMode.values[index]);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Meaning'),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Handwriting'),
        BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
        BottomNavigationBarItem(icon: Icon(Icons.skip_previous), label: 'Previous'),
        BottomNavigationBarItem(icon: Icon(Icons.skip_next), label: 'Next'),
      ],
    );
  }
}
