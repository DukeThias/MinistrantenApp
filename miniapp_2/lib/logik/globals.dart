import 'package:flutter/material.dart';
import '../services/datenspeichern.dart';

class Globals with ChangeNotifier {
  final Map<String, dynamic> _variabeln = {};
  bool initiert = false;

  Globals() {
    variablenInitiieren();
  }
  dynamic get(String key) => _variabeln[key];

  void set(String key, dynamic value) {
    _variabeln[key] = value;
    notifyListeners();
  }

  void setSilent(String key, dynamic value) {
    _variabeln[key] = value;
  }

  Future<void> variablenInitiieren() async {
    setSilent("ministranten", []);
    setSilent("termine", await readJsonFromFile("termine") ?? []);
    setSilent("pong", "nüscht");
    setSilent("nachrichten", []);
    setSilent("gemeinden", []);
    setSilent("hauptseite_index", 0);
    setSilent("self", {});
    setSilent("benutzername", "");
    setSilent("passwort", "");
    setSilent("specialgraphics", false);
    initiert = true;
    notifyListeners();
  }
}
