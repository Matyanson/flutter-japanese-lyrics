import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/routes/song/song_screen.dart';
import '../../components/custom_search_bar.dart';
import '../../components/song_tile.dart';
import 'search_controller.dart';
import '../../database/hive_repository.dart';
import '../library/library_screen.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    final library = HiveRepository();

    void performSearch(String query) async {
      print('start loading!');
      await ref.read(searchResultsProvider.notifier).searchSongs(query);
    }

    void onSongTap(String id) async {
      // vyhledání detailů písně
      ref.read(searchResultsProvider.notifier).expandSongDetails(id);

      // otevřít song detail
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongScreen(songId: id),
        ),
      );
    }

    void onSongAdd(String id) async {
      // vyhledání detailů písně
      final fullSong = await ref.read(searchResultsProvider.notifier).expandSongDetails(id);

      if(fullSong == null) return;

      // Uložení vybrané písně do lokální knihovny pomocí HiveRepository
      final repository = HiveRepository();
      await repository.addSong(fullSong);
      
      if (context.mounted) {
        // Zobrazíme potvrzovací zprávu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Píseň "${fullSong.title}" byla přidána do knihovny.')),
        );

        // Přejdeme na stránku knihovny
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LibraryScreen()),
        );
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('検索 - Japanese Lyrics'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              onSearch: performSearch,
            ),
          ),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Chyba: $err')),
              data: (songs) {
                return songs.isEmpty
                  ? const Center(child: Text('Zadejte název písně pro vyhledávání...'))
                  : ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        final isSongInLibrary = library.getLibraryBox().containsKey(song.id);
                        return SongTile(
                          song: song,
                          onTap: () => onSongTap(song.id),
                          onAdd: isSongInLibrary ? null : () => onSongAdd(song.id),
                        );
                      },
                    );
              }
            )
          ),
        ],
      ),
    );
  }
}