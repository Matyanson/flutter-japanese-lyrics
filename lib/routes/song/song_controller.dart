import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:japanese_lyrics_app/models/song.dart';
import 'package:japanese_lyrics_app/routes/search/search_controller.dart' show searchResultsProvider;


final songProvider = FutureProvider.family<Song?, String>((ref, id) async {
  final searchResults = ref.watch(searchResultsProvider);
  final songInProvider = searchResults.whenOrNull(
    data: (songs) => songs.firstWhereOrNull((s) => s.id == id),
  );

  if (songInProvider != null) {
    return songInProvider;
  }

  final libraryBox = Hive.box<Song>('library');
  return libraryBox.get(id);
});