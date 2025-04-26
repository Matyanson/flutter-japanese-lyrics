// lib/routes/search/search_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/services/jlyrics_api.dart';
import '../../models/song.dart';

final searchResultsProvider = AsyncNotifierProvider<SearchResultsNotifier, List<Song>>(SearchResultsNotifier.new);

class SearchResultsNotifier extends AsyncNotifier<List<Song>> {
  @override
  Future<List<Song>> build() async {
    return []; // Počáteční stav je prázdný seznam
  }

  /// vyhledání písní podle keyword z API
  Future<void> searchSongs(String query) async {
    try{
      final songs = await fetchSongs(query);
      state = AsyncData(songs);
      
    } catch (e) {
      state = AsyncError('Error fetching search results: $e', StackTrace.current);
    }
  }

  /// přidání detailů písně
  Future<Song?> expandSongDetails(String id) async {
    final songs = state.value;
    if (songs == null) {
      throw Exception('Cannot expand song details: not ready');
    }

    final index = songs.indexWhere((s) => s.id == id);
    if (index == -1) throw Exception('Error expanding details: Song not found');
    
    final song = songs[index];
    if(song.lyrics.isNotEmpty) return song;

    try {
      final lyrics = await fetchLyrics(song.url);
      final fullSong = song.copyWithDetails(lyrics);
      final updatedSongs = [...songs];
      updatedSongs[index] = fullSong;
      state = AsyncData(updatedSongs);

      return fullSong;
    } catch (e) {
      print('Error fetching lyrics: ${e}');
    }
    return null;
  }
}