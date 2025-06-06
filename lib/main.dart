import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:japanese_lyrics_app/components/main_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:japanese_lyrics_app/models/song.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializace Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Registrace adapteru
  Hive.registerAdapter(SongAdapter());

  // // 🔥 Smazat starý uložený soubor
  // final libraryFile = File('${appDocDir.path}/library.hive');
  // if (await libraryFile.exists()) {
  //   await libraryFile.delete();
  // }
  
  // Otevření boxu
  await Hive.openBox<Song>('library');
  // await Hive.box('library').clear();
  
  runApp(ProviderScope(child: JapLyricsApp()));
}

class JapLyricsApp extends StatelessWidget {
  const JapLyricsApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Japanese Lyrics App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MainScaffold(),
    );
  }
}
