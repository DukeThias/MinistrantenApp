import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class Websocketverbindung with ChangeNotifier {
  late WebSocketChannel _channel;
  bool _verbunden = false;
  List<String> _nachrichten = [];
  Timer? _reconnectTimer;

  bool get verbunden => _verbunden;
  List<String> get nachrichten => _nachrichten;

  void verbinde(String url) {
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _verbunden = true;
      notifyListeners();

      // Nachrichten empfangen
      _channel.stream.listen(
        (message) {
          _nachrichten.add(message);
          notifyListeners();
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

  void senden(String nachricht) {
    if (_verbunden) {
      _channel.sink.add(nachricht);
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
