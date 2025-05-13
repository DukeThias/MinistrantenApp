import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Löscht eine Dateiwerden die
Future<void> deleteFile(String filename) async {
  try {
    final file = await _getJsonFile(filename);
    if (await file.exists()) {
      await file.delete();
      print('Datei $filename wurde gelöscht.');
    } else {
      print('Datei $filename existiert nicht.');
    }
  } catch (e) {
    print('Fehler beim Löschen der Datei: $e');
  }
}

/// Speichert einen String in eine Datei
Future<void> saveStringToFile(String filename, String value) async {
  final file = await _getJsonFile(filename);
  await file.writeAsString(value);
}

/// Lädt einen String aus einer Datei
Future<String?> readStringFromFile(String filename) async {
  try {
    final file = await _getJsonFile(filename);
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return null;
    }
  } catch (e) {
    print('Fehler beim Lesen der Datei: $e');
    return null;
  }
}

/// Speichert einen booleschen Wert in eine Datei
Future<void> saveBoolToFile(String filename, bool value) async {
  final file = await _getJsonFile(filename);
  await file.writeAsString(value.toString());
}

/// Lädt einen booleschen Wert aus einer Datei
Future<bool?> readBoolFromFile(String filename) async {
  try {
    final file = await _getJsonFile(filename);
    if (await file.exists()) {
      final content = await file.readAsString();
      return content.toLowerCase() == 'true';
    } else {
      return null;
    }
  } catch (e) {
    print('Fehler beim Lesen der Datei: $e');
    return null;
  }
}

Future<String> _getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  print("Local path: ${directory.path}");
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
