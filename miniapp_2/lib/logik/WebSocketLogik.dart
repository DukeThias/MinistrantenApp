import 'package:miniapp_2/logik/Nachricht.dart';
import 'package:miniapp_2/logik/globals.dart';

class WebSocketLogik {
  final Globals globals = Globals();
  void verarbeiteNachricht(Nachricht nachricht) {
    // Aktion basierend auf der Art der Nachricht ausführen

    switch (nachricht.art) {
      case 'miniplan':
        _handleMiniplan(nachricht);
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
}
