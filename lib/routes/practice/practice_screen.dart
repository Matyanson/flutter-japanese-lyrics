import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/routes/practice/components/practice_content.dart';
import 'package:japanese_lyrics_app/routes/practice/components/practice_header.dart';
import 'package:japanese_lyrics_app/routes/practice/components/practice_mode_selector.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_controller.dart';

class PracticeScreen extends ConsumerStatefulWidget {
  final String songId;

  const PracticeScreen({super.key, required this.songId});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  
  @override
  Widget build(BuildContext context) {
    final songState = ref.watch(practiceControllerProvider(widget.songId));

    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: songState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (song) => Column(
          children: [
            Expanded(
              child: PracticeHeader(songId:  widget.songId) // věta a slovo
            ),
            Expanded(
              child: PracticeContent(songId: widget.songId), // mění se podle módu
            ),
            PracticeModeSelector(songId: widget.songId), // menu dole
          ],
        ),
      ),
    );
  }
}
