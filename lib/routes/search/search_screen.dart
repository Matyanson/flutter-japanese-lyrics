import 'package:flutter/material.dart';
import '../../components/custom_search_bar.dart';
import '../../components/song_tile.dart';
import '../../models/song.dart';
import 'search_controller.dart';
import '../../database/hive_repository.dart';
import '../library/library_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Song> searchResults = [];
  bool isLoading = false;

  void _performSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    // Načtení písniček pomocí controlleru
    final results = await fetchSongs(query);
    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  void _onSongTap(Song song) async {
    // vyhledání detailů písně
    final lyrics = await fetchLyrics(song.url);
    song.lyrics = lyrics;

    // Uložení vybrané písně do lokální knihovny pomocí HiveRepository
    final repository = HiveRepository();
    await repository.addSong(song);

    // Zobrazíme potvrzovací zprávu
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Píseň "${song.title}" byla přidána do knihovny.')),
    );

    // Přejdeme na stránku knihovny
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LibraryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? const Center(child: Text('Zadejte název písně pro vyhledávání...'))
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final song = searchResults[index];
                          return SongTile(
                            song: song,
                            onTap: () => _onSongTap(song),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
