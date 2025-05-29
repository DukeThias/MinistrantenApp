import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/Nachricht.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocketverbindung with ChangeNotifier {
  late WebSocketChannel _channel;
  bool _verbunden = false;
  final List<Nachricht> _nachrichten = [];
  Timer? _reconnectTimer;
  String? _username;
  String? _passwort;

  void setAnmeldedaten(String? username, String? passwort) {
    _username = username;
    _passwort = passwort;
  }

  final WebSocketLogik _logik = WebSocketLogik();

  bool get verbunden => _verbunden;
  List<Nachricht> get nachrichten => _nachrichten;

  Future<void> verbinde(String url) async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Nachrichten empfangen
      _channel.stream.listen(
        (message) {
          if (!_verbunden) {
            _verbunden = true;
            notifyListeners();
            if (_username != null &&
                _passwort != null &&
                _username!.isNotEmpty &&
                _passwort!.isNotEmpty) {
              senden(
                "anmeldung",
                jsonEncode({"Username": _username, "Passwort": _passwort}),
              );
            }
          }

          try {
            final decoded = jsonDecode(message);
            final nachricht = Nachricht.fromJson(decoded);
            _nachrichten.add(nachricht);
            notifyListeners();
            _logik.verarbeiteNachricht(nachricht);
          } catch (e) {
            print("Ungültige Nachricht: $e");
          }
        },
        onDone: () {
          print("Verbindung geschlossen (onDone).");
          try {
            _channel.sink.close();
          } catch (e) {
            print("Fehler beim Schließen des WebSocket-Kanals: $e");
          }
          _verbunden = false;
          notifyListeners();
          _versucheWiederzuverbinden(url);
        },
        onError: (error) {
          print("Fehler im WebSocket-Stream: $error");
          _verbunden = false;
          notifyListeners();
          _versucheWiederzuverbinden(url);
        },
        cancelOnError: true,
      );
    } catch (e) {
      print("Fehler beim Verbindungsaufbau: $e");
      _verbunden = false;
      notifyListeners();
      _versucheWiederzuverbinden(url);
    }
  }

  void sendHtmlPlanFile(String fileName, String content) {
    final payload = {
      'type': 'uploadHtmlPlan',
      'filename': fileName,
      'content': content,
    };
    print(
      "Sende HTML-Plan-Datei: $fileName mit Inhalt: ${content.length} Zeichen",
    );

    _channel.sink.add(jsonEncode(payload));
  }

  void senden(String art, inhalt) {
    if (_verbunden) {
      final nachricht = Nachricht(
        art: art,
        inhalt: inhalt,
        timestamp: DateTime.now(),
      );
      final jsonString = jsonEncode(nachricht.toJson());
      _channel.sink.add(jsonString);
    }
  }

  void trennen() {
    _reconnectTimer?.cancel();
    _channel.sink.close();
    _verbunden = false;
    notifyListeners();
  }

  void _versucheWiederzuverbinden(String url) {
    if (_reconnectTimer != null && _reconnectTimer!.isActive) {
      print("Wiederverbindung bereits aktiv. Kein neuer Timer gestartet.");
      return;
    }

    // Wiederverbindung alle 5 Sekunden versuchen
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!_verbunden) {
        print("Versuche, die Verbindung wiederherzustellen...");
        try {
          await verbinde(url);
        } catch (e) {
          print("Fehler beim Wiederverbinden: $e");
        }
      } else {
        print("Verbindung wiederhergestellt. Timer wird gestoppt.");
        timer.cancel();
      }
    });
  }
}
