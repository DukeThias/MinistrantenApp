import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

class Websocketverbindung with ChangeNotifier {
  late WebSocketChannel _channel;
  bool _verbunden = false;
  List<String> _nachrichten = [];

  bool get verbunden => _verbunden;
  List<String> get nachrichten => _nachrichten;

  void verbinde(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _verbunden = true;
    notifyListeners();

    _channel.stream.listen(
      (message) {
        _nachrichten.add(message);
        notifyListeners();
      },
      onDone: () {
        _verbunden = false;
        notifyListeners();
      },
      onError: (error) {
        _verbunden = false;
        notifyListeners();
      },
    );
    _verbunden = true;
    notifyListeners();
  }

  void senden(String nachricht) {
    if (_verbunden) {
      _channel.sink.add(nachricht);
    }
  }

  void trennen() {
    _channel.sink.close();
    _verbunden = false;
    notifyListeners();
  }
}
