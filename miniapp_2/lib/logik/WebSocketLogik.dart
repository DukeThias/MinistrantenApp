import 'package:miniapp_2/logik/Nachricht.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:flutter/material.dart';
import 'package:miniapp_2/main.dart';
import '../ui/hauptseite.dart';

class WebSocketLogik with ChangeNotifier {
  final TextEditingController _controllerBenutzername = TextEditingController();
  final Globals globals = Globals();
  void verarbeiteNachricht(Nachricht nachricht) {
    switch (nachricht.art) {
      case 'miniplan':
        _handleMiniplan(nachricht);
        break;
      case 'authentifizierung':
        _handleAuthentifizierung(nachricht);
        break;
      case 'namensliste':
        _handleNamensliste(nachricht);
        break;
      case 'rollen':
        _handleRollen(nachricht);
        break;
      case 'pong':
        _handlePong(nachricht);
      default:
        print("Unbekannte Nachrichtsart: ${nachricht.art}");
    }
  }

  void _handleMiniplan(Nachricht nachricht) {
    globals.set("miniplan", nachricht.inhalt);
  }

  void _handleNamensliste(Nachricht nachricht) {
    globals.set("namensliste", nachricht.inhalt);
  }

  void _handleRollen(Nachricht nachricht) {
    globals.set("rollen", nachricht.inhalt);
  }

  void _handlePong(Nachricht nachricht) {
    globals.set("pong", nachricht.inhalt);
  }

  void _handleAuthentifizierung(Nachricht nachricht) {
    if (nachricht.inhalt == "true") {
      globals.set("angemeldet", true);
      globals.set("benutzername", _controllerBenutzername.text);
      List teile = _controllerBenutzername.text.split(".");

      globals.set("anmeldename", teile.sublist(1).join(" "));
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => Hauptseite()),
      );
    } else {
      print("Authentifizierung fehlgeschlagen: ${nachricht.inhalt}");
    }
  }
}
