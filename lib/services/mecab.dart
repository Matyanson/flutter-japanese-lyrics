import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/services/mecab_helper.dart';
import 'package:mecab_for_flutter/mecab_for_flutter.dart';

final mecabProvider = AsyncNotifierProvider<MecabController, bool>(
  MecabController.new,
);

class MecabController extends AsyncNotifier<bool> {
  late Mecab tagger;

  @override
  Future<bool> build() async {
    tagger = Mecab();
    final ipaDictPath = await getDictDir();

    await tagger.initFlutter(ipaDictPath, false);

    print('mecab is ready');
    return true; // Mecab is ready
  }

  List<TokenNode> parse(String text) {
    return tagger.parse(text);
  }
}