// lib/routes/song/song_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:japanese_lyrics_app/database/hive_repository.dart';
import 'package:japanese_lyrics_app/routes/song/song_controller.dart';

class SongScreen extends ConsumerWidget {
  final String songId;

  const SongScreen({super.key, required this.songId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songAsync = ref.watch(songProvider(songId));
    final library = HiveRepository();

    return Scaffold(
      appBar: AppBar(),
      body: songAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error loading song')),
        data: (song) {
          if (song == null) {
            return const Center(child: Text('Song not found'));
          }
          final hasLyrics = song.lyrics.isNotEmpty;
          final isSongInLibrary = library.getLibraryBox().containsKey(song.id);

          void removeFromLibrary() {
            library.removeSong(songId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Píseň "${song.title}" byla odebrána z knihovny.')),
            );
          }
          void addToLibrary() {
            library.addSong(song);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Píseň "${song.title}" byla přidána do knihovny.')),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Artist: ${song.artist}', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                const Text('Lyrics:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: !hasLyrics
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    itemCount: song.lyrics.length,
                    itemBuilder: (context, index) {
                      return Text('${index + 1}. ${song.lyrics[index]}');
                    },
                  ),
                ),
                if(hasLyrics) FloatingActionButton(
                  onPressed: isSongInLibrary ? removeFromLibrary : addToLibrary,
                  child: Icon(isSongInLibrary ? Icons.delete : Icons.add),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
