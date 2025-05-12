import 'package:flutter/material.dart';

class Globals with ChangeNotifier {
  final Map<String, dynamic> _variabeln = {};

  dynamic get(String key) => _variabeln[key];

  void set(String key, dynamic value) {
    _variabeln[key] = value;
    notifyListeners();
  }

  void variablenInitiieren() {
    set("rollen", []);
    set("benutzername", "");
    set("namensliste", []);
    set("miniplan", []);
    set("pong", "nüscht");
  }
}
