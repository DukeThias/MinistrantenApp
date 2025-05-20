import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:miniapp_2/logik/Nachricht.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:flutter/material.dart';
import 'package:miniapp_2/main.dart';
import '../ui/hauptseite.dart';
import '../services/datenspeichern.dart';
import '../ui/anmeldeseite.dart';

class WebSocketLogik with ChangeNotifier {
  Globals get globals => navigatorKey.currentContext!.read<Globals>();

  void verarbeiteNachricht(Nachricht nachricht) {
    print("Nachricht empfangen: ${nachricht.toJson()}");
    switch (nachricht.art) {
      case 'authentifizierung':
        _handleAuthentifizierung(nachricht);
        break;

      case 'gemeinden':
        globals.set("gemeinden", jsonDecode(nachricht.inhalt));
        print("Gemeinden: ${globals.get("gemeinden")}");
        break;

      case 'ministranten':
        globals.set("ministranten", jsonDecode(nachricht.inhalt));
        print("Ministranten: ${globals.get("ministranten")}");
        break;

      case 'nachrichten':
        globals.set("nachrichten", jsonDecode(nachricht.inhalt));
        print("Nachrichten: ${globals.get("nachrichten")}");
        break;

      case 'rollen':
        _handleRollen(nachricht);
        break;

      case 'termine':
        _handleTermine(nachricht);
        break;

      case 'pong':
        _handlePong(nachricht);

      case 'handshake':
        print("Handshake erfolgreich: ${nachricht.inhalt}");
        break;
      default:
        print("Unbekannte Nachrichtsart: ${nachricht.art}");
    }
  }

  void _handleTermine(Nachricht nachricht) {
    globals.set("termine", jsonDecode(nachricht.inhalt));
    saveJsonToFile("termine", jsonDecode(nachricht.inhalt));
    print("Termine: ${globals.get("termine")}");
  }

  void _handleRollen(Nachricht nachricht) {
    globals.set("rollen", nachricht.inhalt);
  }

  void _handlePong(Nachricht nachricht) {
    globals.set("pong", nachricht.inhalt);
  }

  void _handleAuthentifizierung(Nachricht nachricht) {
    //nachricht.inhalt enthält json
    dynamic status = jsonDecode(nachricht.inhalt);
    if (status["success"]) {
      print("Authentifizierung erfolgreich: ${nachricht.inhalt}");
      var person = status["person"];
      globals.set("angemeldet", true);
      final self = globals.get("self") ?? {};
      self.addAll(person);
      globals.set("self", self);

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => Hauptseite()),
      );
    } else {
      Future.delayed(Duration.zero, () {
        final context = navigatorKey.currentContext!;
        final currentRoute = ModalRoute.of(context)?.settings.name;

        print("Aktuelle Route (verzögert): $currentRoute");

        if (currentRoute != "/anmeldeseite") {
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Anmeldeseite()),
            (Route<dynamic> route) => false,
          );
        }
      });
      deleteFile("anmeldedaten");
      print("Authentifizierung fehlgeschlagen: ${status["message"]}");
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Authentifizierung fehlgeschlagen: ${status["message"]}",
          ),
        ),
      );
    }
  }
}
