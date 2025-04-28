import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/models/song.dart';

final practiceControllerProvider = AsyncNotifierProviderFamily<PracticeController, Song, String>(
  PracticeController.new
);

class PracticeController extends FamilyAsyncNotifier<Song, String> {
  late PracticeMode mode;
  late Song song;
  int currentLineIndex = 0;
  int currentWordIndex = 0;
  List<String> words = [];

  @override
  Future<Song> build(String id) async {
    print('load song');
    final box = Hive.box<Song>('library');
    final song = box.get(id);

    if (song == null) {
      throw Exception('Song not found');
    }

    mode = PracticeMode.meaning;
    currentLineIndex = 0;
    currentWordIndex = 0;
    this.song = song;
    words = lineToTokens();

    return song;
  }

  List<String> lineToTokens() {
    return song.lyrics[currentLineIndex].split(' ');
  }

  void changeMode(PracticeMode newMode) {
    mode = newMode;
    state = AsyncData(song);
  }

  void nextLine() {
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
    state = AsyncData(song);
  }

  String get currentLine {
    return song.lyrics[currentLineIndex];
  }

  String get currentWord {
    if (currentWordIndex < words.length) {
      return words[currentWordIndex];
    } else {
      return '';
    }
  }
}
