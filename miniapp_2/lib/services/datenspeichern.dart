import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> _getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _getJsonFile(String filename) async {
  final path = await _getLocalPath();
  return File('$path/$filename.json');
}

/// Speichert JSON-Daten in eine Datei
Future<void> saveJsonToFile(String filename, Map<String, dynamic> data) async {
  final file = await _getJsonFile(filename);
  final jsonString = jsonEncode(data);
  await file.writeAsString(jsonString);
}

/// Lädt JSON-Daten aus einer Datei
Future<Map<String, dynamic>?> readJsonFromFile(String filename) async {
  try {
    final file = await _getJsonFile(filename);
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } else {
      return null;
    }
  } catch (e) {
    print('Fehler beim Lesen der Datei: $e');
    return null;
  }
}
