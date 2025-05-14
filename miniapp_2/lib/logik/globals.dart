import 'package:flutter/material.dart';

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

  void variablenInitiieren() {
    setSilent("rollen", ["nutzer"]);
    setSilent("benutzername", "");
    setSilent("passwort", "");
    setSilent("namensliste", []);
    setSilent("miniplan", []);
    setSilent("termine", []);
    setSilent("pong", "nüscht");
    setSilent("anmeldename", "");
    setSilent("angemeldet", false);
    setSilent("gemeinden", []);
    setSilent("hauptseite_index", 0);
    initiert = true;
    notifyListeners();
  }
}
