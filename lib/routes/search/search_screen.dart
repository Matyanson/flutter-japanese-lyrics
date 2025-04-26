import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    void _performSearch(String query) async {
      await ref.read(searchResultsProvider.notifier).searchSongs(query);
    }

    void _onSongTap(int index) async {
      // vyhledání detailů písně
      final fullSong = await ref.read(searchResultsProvider.notifier).expandSongDetails(index);

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
              onSearch: _performSearch,
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
                        return SongTile(
                          song: song,
                          onTap: () => _onSongTap(index),
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