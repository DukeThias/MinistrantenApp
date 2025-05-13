import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import '../services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../logik/globals.dart';

class Anmeldeseite extends StatefulWidget {
  @override
  _AnmeldeseiteState createState() => _AnmeldeseiteState();
}

class _AnmeldeseiteState extends State<Anmeldeseite> {
  late String uniqheId;

  late WebSocketLogik wsLogik;

  bool angemeldetbleiben = false;

  bool passwortausblenden = true;

  final TextEditingController _controllerBenutzername = TextEditingController();

  final TextEditingController _controllerPasswort = TextEditingController();

  @override
  void initState() {
    super.initState();
    uniqheId = Uuid().v4();
    Globals().variablenInitiieren();
    wsLogik = Provider.of<WebSocketLogik>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ws = context.read<Websocketverbindung>();
      if (!ws.verbunden) {
        ws.verbinde("ws://localhost:5205/ws?id=$uniqheId");
      }
    });
  }

  @override
  void dispose() {
    _controllerBenutzername.dispose();
    _controllerPasswort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Login"),
            Icon(Icons.circle, color: ws.verbunden ? Colors.green : Colors.red),
            ElevatedButton(
              onPressed: () {
                final anmeldedaten = {
                  "benutzername": "benutzername",
                  "passwort": "passwort",
                };
                ws.senden("anmeldung", jsonEncode(anmeldedaten));
              },
              child: Text("Anmelden"),
            ),
          ],
        ),
      ),
      body: Center(child: Text("anmelden")),
    );
  }
}
