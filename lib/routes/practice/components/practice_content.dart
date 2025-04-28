import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/components/handwriting_canvas.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeContent extends ConsumerWidget {
  final String songId;

  void onPrediction(List<String> predictions) {
    print('new predictions! ${predictions.length}');
    for (var word in predictions) {
      print(word);
    }
  }

  const PracticeContent({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider(songId).notifier);

    switch (controller.mode) {
      case PracticeMode.meaning:
        return const Center(child: Text('Meaning explanation'));
      case PracticeMode.handwriting:
        return HandwritingRecognizer(onPrediction: onPrediction);
      case PracticeMode.image:
        return const Center(child: Text('Image representation'));
    }
  }
}
