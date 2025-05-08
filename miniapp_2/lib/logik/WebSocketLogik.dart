import 'dart:convert';

String verarbeiteNachricht(String rohdaten) {
  try {
    var data = jsonDecode(rohdaten);
    switch (data['aktion']) {
      case 'infos':
        return "Nachricht: ${data['content']}";
      case 'update':
        return "Fehler: ${data['content']}";
      default:
        return "Unbekannter Typ: ${data['type']}";
    }
  } catch (_) {
    return "Rohtext: $rohdaten";
  }
}
