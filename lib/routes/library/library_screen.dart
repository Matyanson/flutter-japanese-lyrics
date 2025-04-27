import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:japanese_lyrics_app/routes/practice/practice_screen.dart';
import '../../models/song.dart';
import 'package:japanese_lyrics_app/routes/song/song_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Otevřeme již dříve inicializovaný box s názvem 'library'
    final box = Hive.box<Song>('library');

    void onSongPressed(String id) {
      print('Id Songy: $id');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SongScreen(songId: id),
        ),
      );
    }

    void onSongBegin(String id) {
      print('Practice song: $id');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeScreen(songId: id),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knihovna písní'),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Song> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('Knihovna je prázdná.'),
            );
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              Song song = box.getAt(index)!;
              return ListTile(
                title: Text(song.title),
                subtitle: Text(song.artist),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => onSongBegin(song.id),
                ),
                onTap: () {
                  // Zde můžeš přidat přechod do detailu písně či další logiku.
                  print('Vybrána píseň: ${song.title}');
                  onSongPressed(song.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}
