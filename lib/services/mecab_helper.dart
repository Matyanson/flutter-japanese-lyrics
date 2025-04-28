import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getDictDir() async {
  final appDocDir = await getApplicationDocumentsDirectory();
  final dictPath = '${appDocDir.path}/ipadic/';

  final dictDirectory = Directory(dictPath);

  if (await dictDirectory.exists()) {
    return dictPath;
  }

  // Create the directory
  await dictDirectory.create(recursive: true);

  // Load AssetManifest.json
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  // Find all assets under assets/ipadic/
  final files = manifestMap.keys.where((String key) => key.startsWith('assets/ipadic/')).toList();

  for (final assetPath in files) {
    final data = await rootBundle.load(assetPath);
    final List<int> bytes = data.buffer.asUint8List();

    final file = File('${appDocDir.path}/${assetPath.replaceFirst('assets/', '')}');
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);
  }

  return dictPath;
}