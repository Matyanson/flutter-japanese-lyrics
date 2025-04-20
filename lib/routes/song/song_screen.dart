// lib/routes/song/song_screen.dart
import 'package:flutter/material.dart';
import 'package:japanese_lyrics_app/models/song.dart';
import 'package:japanese_lyrics_app/routes/song/song_controller.dart';

class SongScreen extends StatefulWidget {
  final int songIndex;

  const SongScreen({super.key, required this.songIndex});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  Song? song;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSong();
  }

  Future<void> _loadSong() async {
    final loadedSong = await fetchSongById(widget.songIndex);
    setState(() {
      song = loadedSong;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (song == null) return const Center(child: Text('Song not found'));

    return Scaffold(
      appBar: AppBar(
        title: Text(song!.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Artist: ${song!.artist}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Lyrics:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: song!.lyrics.length,
                itemBuilder: (context, index) {
                  return Text('${index + 1}. ${song!.lyrics[index]}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
