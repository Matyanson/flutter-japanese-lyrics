import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/practice_mode.dart';
import 'package:japanese_lyrics_app/models/song.dart';
import 'package:japanese_lyrics_app/services/mecab.dart';
import 'package:japanese_lyrics_app/services/voicevox_service.dart';
import 'package:ringo/ringo.dart';

final practiceControllerProvider = AsyncNotifierProviderFamily<PracticeController, Song, String>(
  PracticeController.new
);

class PracticeController extends FamilyAsyncNotifier<Song, String> {
  late MecabController mecabController;
  late Ringo ringo;
  late VoiceVoxService voiceVoxService;
  late PracticeMode mode;
  late Song song;
  int currentLineIndex = 0;
  int currentWordIndex = 0;
  List<String> words = [];

  @override
Future<Song> build(String id) async {
  final box = Hive.box<Song>('library');
  final song = box.get(id);

  if (song == null) {
    throw Exception('Song not found');
  }

  // Wait until mecabProvider finishes loading
  ringo = await Ringo.init();
  await ref.read(mecabProvider.future);
  voiceVoxService = VoiceVoxService();

  mecabController = ref.read(mecabProvider.notifier);

  mode = PracticeMode.meaning;
  currentLineIndex = 0;
  currentWordIndex = 0;
  this.song = song;
  words = await lineToTokens();
  readCurrentWord();

  return song;
}

  Future<List<String>> lineToTokens() async {
    print('lineToTokens');
    final line = song.lyrics[currentLineIndex];
    print(line);

    final tokens = ringo.tokenize(line);
    tokens.removeWhere((t) => t.trim().isEmpty);
    if(tokens.length <= 1) {
      return line.split(' ');
    }

    return tokens;

    // final testTokens = mecabController.tagger.parse(line);
    // final testTokensArray = testTokens.map((token) => token.surface).toList(); 
    // for (final token in testTokensArray) {
    //   print(token);
    // }
  }

  void changeMode(PracticeMode newMode) {
    mode = newMode;
    state = AsyncData(song);
  }

  void nextLine() async {
    if(currentLineIndex + 1 < song.lyrics.length) {
      currentLineIndex++;
      words = await lineToTokens();
      currentWordIndex = 0;
    }
  }

  void previousLine() async {
    if (currentLineIndex > 0) {
      currentLineIndex--;
      words = await lineToTokens();
      currentWordIndex = words.length - 1;
    }
  }

  Future<void> nextWord() async {
    if (currentWordIndex + 1 < words.length) {
      currentWordIndex++;
    } else {
      nextLine();
    }

    readCurrentWord();
    state = AsyncData(song);
  }

  void previousWord() async {
    if (currentWordIndex > 0) {
      currentWordIndex--;
    } else {
      previousLine();
    }

    readCurrentWord();
    state = AsyncData(song);
  }

  void readCurrentWord() async {
    await voiceVoxService.speak(currentWord);
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
