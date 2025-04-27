import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/models/song.dart';

final practiceControllerProvider = AsyncNotifierProvider<PracticeController, Song>(PracticeController.new);

class PracticeController extends AsyncNotifier<Song> {
  late PracticeMode mode;
  int currentLineIndex = 0;
  int currentWordIndex = 0;

  @override
  Future<Song> build() async {
    // Inicializace probíhá až v loadSong()
    throw UnimplementedError();
  }

  Future<void> loadSong(String id) async {
    final box = Hive.box<Song>('library');
    final song = box.get(id);

    if (song == null) {
      state = const AsyncError('Song not found', StackTrace.empty);
    } else {
      mode = PracticeMode.meaning;
      currentLineIndex = 0;
      currentWordIndex = 0;
      state = AsyncData(song);
    }
  }

  void changeMode(PracticeMode newMode) {
    mode = newMode;
    state = AsyncData(state.requireValue);
  }

  void nextWord() {
    final song = state.requireValue;
    final line = song.lyrics[currentLineIndex];
    final words = line.split(' '); // nebo jiná logika dělení slov
    if (currentWordIndex + 1 < words.length) {
      currentWordIndex++;
    } else if (currentLineIndex + 1 < song.lyrics.length) {
      currentLineIndex++;
      currentWordIndex = 0;
    }
    state = AsyncData(song);
  }

  void previousWord() {
    if (currentWordIndex > 0) {
      currentWordIndex--;
    } else if (currentLineIndex > 0) {
      currentLineIndex--;
      currentWordIndex = state.requireValue.lyrics[currentLineIndex].split(' ').length - 1;
    }
    state = AsyncData(state.requireValue);
  }

  String get currentLine {
    return state.requireValue.lyrics[currentLineIndex];
  }

  String get currentWord {
    final line = currentLine;
    final words = line.split(' '); // opět, můžeš později udělat lepší split
    if (currentWordIndex < words.length) {
      return words[currentWordIndex];
    } else {
      return '';
    }
  }
}
