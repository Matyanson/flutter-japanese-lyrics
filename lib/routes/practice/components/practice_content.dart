import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeContent extends ConsumerWidget {
  final String songId;

  const PracticeContent({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider(songId).notifier);

    switch (controller.mode) {
      case PracticeMode.meaning:
        return const Center(child: Text('Meaning explanation'));
      case PracticeMode.handwriting:
        return const Center(child: Text('Handwriting practice'));
      case PracticeMode.image:
        return const Center(child: Text('Image representation'));
    }
  }
}
