import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/models/song.dart';

final practiceControllerProvider = AsyncNotifierProvider<PracticeController, Song>(PracticeController.new);

class PracticeController extends AsyncNotifier<Song> {
  late PracticeMode mode;
  int currentLineIndex = 0;
  int currentWordIndex = 0;
  List<String> tokens = [];

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
      tokens = lineToTokens();
      state = AsyncData(song);
    }
  }

  List<String> lineToTokens() {
    return state.requireValue.lyrics[currentLineIndex].split(' ');
  }

  void changeMode(PracticeMode newMode) {
    mode = newMode;
    state = AsyncData(state.requireValue);
  }

  void nextLine() {
    final song = state.requireValue;
    if(currentLineIndex + 1 < song.lyrics.length) {
      currentLineIndex++;
      tokens = lineToTokens();
      currentWordIndex = 0;
    }
  }

  void previousLine() {
    if (currentLineIndex > 0) {
      currentLineIndex--;
      tokens = lineToTokens();
      currentWordIndex = tokens.length - 1;
    }
  }

  void nextWord() {
    final song = state.requireValue;
    final line = song.lyrics[currentLineIndex];
    final words = line.split(' '); // nebo jiná logika dělení slov
    if (currentWordIndex + 1 < words.length) {
      currentWordIndex++;
    } else {
      nextLine();
    }
    state = AsyncData(song);
  }

  void previousWord() {
    if (currentWordIndex > 0) {
      currentWordIndex--;
    } else {
      previousLine();
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
