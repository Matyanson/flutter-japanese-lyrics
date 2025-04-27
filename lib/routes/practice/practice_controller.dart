import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/models/song.dart';

final practiceControllerProvider = AsyncNotifierProvider<PracticeController, Song>(PracticeController.new);

class PracticeController extends AsyncNotifier<Song> {
  late PracticeMode mode;
  int currentLineIndex = 0;
  int currentWordIndex = 0;
  List<String> words = [];

  @override
  Future<Song> build() async {
    // Inicializace probíhá až v loadSong()
    // throw UnimplementedError();

    return Song(id: 'in', title: 'Placeholder', artist: 'placeholder', lyrics: ['lyrics'], url: 'url');
  }

  Future<void> loadSong(String id) async {
    print('load song');
    final box = Hive.box<Song>('library');
    final song = box.get(id);

    if (song == null) {
      state = const AsyncError('Song not found', StackTrace.empty);
    } else {
      mode = PracticeMode.meaning;
      currentLineIndex = 0;
      currentWordIndex = 0;
      words = lineToTokens();
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
      words = lineToTokens();
      currentWordIndex = 0;
    }
  }

  void previousLine() {
    if (currentLineIndex > 0) {
      currentLineIndex--;
      words = lineToTokens();
      currentWordIndex = words.length - 1;
    }
  }

  void nextWord() {
    final song = state.requireValue;
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
    if (currentWordIndex < words.length) {
      return words[currentWordIndex];
    } else {
      return '';
    }
  }
}
