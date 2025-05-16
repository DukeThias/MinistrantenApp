import 'package:flutter/material.dart';

class Verbindungsstatus extends ChangeNotifier {
  bool zeigeWiederVerbunden = false;

  void triggerOnlineHinweis() {
    zeigeWiederVerbunden = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      zeigeWiederVerbunden = false;
      notifyListeners();
    });
  }
}
