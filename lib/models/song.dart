import 'package:hive/hive.dart';

part 'song.g.dart'; // Tento soubor se vygeneruje pomocí build_runner

@HiveType(typeId: 0)
class Song {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String artist;

  @HiveField(2)
  final List<String> lyrics;

  Song({
    required this.title,
    required this.artist,
    required this.lyrics,
  });
}
