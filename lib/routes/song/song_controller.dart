import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:japanese_lyrics_app/models/song.dart';
import 'package:japanese_lyrics_app/routes/search/search_controller.dart' show searchResultsProvider;


final songProvider = FutureProvider.family<Song?, String>((ref, id) async {
  print('entered songProvider: $id');
  final libraryBox = Hive.box<Song>('library');
  final songInLibrary =  libraryBox.get(id);
  
  print('Id in song_controller1: $id');

  if (songInLibrary != null) {
    return songInLibrary;
  }

  final searchResults = ref.watch(searchResultsProvider);
  final songInProvider = searchResults.whenOrNull(
    data: (songs) => songs.firstWhereOrNull((s) => s.id == id),
  );
  
  print('Id in song_controller2: $id');

  return songInProvider;  
});