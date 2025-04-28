import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/components/handwriting/handwriting_canvas.dart';
import 'package:japanese_lyrics_app/components/handwriting/handwriting_canvas_controller.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeContent extends ConsumerWidget {
  final String songId;

  const PracticeContent({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(practiceControllerProvider(songId).notifier);
    final canvasController = CanvasController();

    
    void onPrediction(List<String> predictions) {
      final currentWord = controller.currentWord;
      if(controller.currentWord.isEmpty) {
        controller.nextWord();
        canvasController.clear();
        return;
      }
      final firstChar = currentWord[0];
      for (var word in predictions) {
        if(word == currentWord || word == firstChar) {
          controller.nextWord();
          canvasController.clear();
          return;
        }
      }
    }

    switch (controller.mode) {
      case PracticeMode.meaning:
        return const Center(child: Text('Meaning explanation'));
      case PracticeMode.handwriting:
        return HandwritingRecognizer(onPrediction: onPrediction, controller: canvasController);
      case PracticeMode.image:
        return const Center(child: Text('Image representation'));
    }
  }
}
