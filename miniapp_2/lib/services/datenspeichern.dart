import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:idb_shim/idb_browser.dart';

Future<Database> _openWebDb() async {
  final idbFactory = getIdbFactory()!;
  return await idbFactory.open(
    'AppDb',
    version: 1,
    onUpgradeNeeded: (e) {
      final db = e.database;
      if (!db.objectStoreNames.contains('jsonfiles')) {
        db.createObjectStore('jsonfiles');
      }
    },
  );
}

Future<void> saveJson(String filename, dynamic data) async {
  if (kIsWeb) {
    final db = await _openWebDb();
    final txn = db.transaction('jsonfiles', idbModeReadWrite);
    final store = txn.objectStore('jsonfiles');
    await store.put(jsonEncode(data), filename);
    await txn.completed;
  } else {
    final file = await _getLocalFile(filename);
    await file.writeAsString(jsonEncode(data));
  }
}

Future<dynamic> readJson(String filename) async {
  if (kIsWeb) {
    final db = await _openWebDb();
    final txn = db.transaction('jsonfiles', idbModeReadOnly);
    final store = txn.objectStore('jsonfiles');
    final result = await store.getObject(filename);
    await txn.completed;
    return result != null ? jsonDecode(result as String) : null;
  } else {
    final file = await _getLocalFile(filename);
    if (await file.exists()) {
      final content = await file.readAsString();
      return jsonDecode(content);
    }
    return null;
  }
}

Future<void> deleteJson(String filename) async {
  if (kIsWeb) {
    final db = await _openWebDb();
    final txn = db.transaction('jsonfiles', idbModeReadWrite);
    final store = txn.objectStore('jsonfiles');
    await store.delete(filename);
    await txn.completed;
  } else {
    final file = await _getLocalFile(filename);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

Future<io.File> _getLocalFile(String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  return io.File('${dir.path}/$filename.json');
}
