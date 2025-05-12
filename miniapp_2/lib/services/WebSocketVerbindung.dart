import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/Nachricht.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocketverbindung with ChangeNotifier {
  late WebSocketChannel _channel;
  bool _verbunden = false;
  List<Nachricht> _nachrichten = [];
  Timer? _reconnectTimer;

  final WebSocketLogik _logik = WebSocketLogik();

  bool get verbunden => _verbunden;
  List<Nachricht> get nachrichten => _nachrichten;

  void verbinde(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _verbunden = true;
      notifyListeners();

      // Nachrichten empfangen
      _channel.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);
            final nachricht = Nachricht.fromJson(decoded);
            _nachrichten.add(nachricht);
            notifyListeners();
            _logik.verarbeiteNachricht(message);
          } catch (e) {
            print("Ungültige Nachricht: $e");
          }
        },
        onDone: () {
          print("Verbindung geschlossen (onDone).");
          try {
            _channel.sink.close(); // Schließe den WebSocket-Kanal
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

          // Verhindere, dass die App abstürzt
          if (error is WebSocketChannelException) {
            print("WebSocketChannelException aufgetreten: ${error.message}");
          }
          _versucheWiederzuverbinden(url);
        },
      );
    } catch (e) {
      print("Fehler beim Verbindungsaufbau: $e");
      _verbunden = false;
      notifyListeners();
      _versucheWiederzuverbinden(url);
    }
  }

  void senden(String art, String inhalt) {
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
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_verbunden) {
        print("Versuche, die Verbindung wiederherzustellen...");
        try {
          verbinde(url);
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
