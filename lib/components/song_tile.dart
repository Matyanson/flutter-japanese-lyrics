// lib/components/song_tile.dart
import 'package:flutter/material.dart';
import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const SongTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(song.title),
      subtitle: Text(song.artist),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward),
    );
  }
}
