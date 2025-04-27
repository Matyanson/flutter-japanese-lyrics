import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeModeSelector extends ConsumerWidget {
  const PracticeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider.notifier);

    return BottomNavigationBar(
      currentIndex: controller.mode.index,
      onTap: (index) {
        controller.changeMode(PracticeMode.values[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.translate), label: 'Meaning'),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Handwriting'),
        BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
      ],
    );
  }
}
