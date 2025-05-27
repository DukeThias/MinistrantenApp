// file_reader.dart
import 'dart:io';

Future<String> readFileNative(String path) async {
  return File(path).readAsString();
}
