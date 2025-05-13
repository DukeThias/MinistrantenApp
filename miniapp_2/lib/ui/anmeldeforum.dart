import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import 'dart:convert';

class AnmeldeFormular extends StatefulWidget {
  @override
  _AnmeldeFormularState createState() => _AnmeldeFormularState();
}

class _AnmeldeFormularState extends State<AnmeldeFormular> {
  final TextEditingController _controllerBenutzername = TextEditingController();
  final TextEditingController _controllerPasswort = TextEditingController();

  @override
  void dispose() {
    _controllerBenutzername.dispose();
    _controllerPasswort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.read<Websocketverbindung>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controllerBenutzername,
          decoration: InputDecoration(labelText: "Benutzername"),
        ),
        TextField(
          controller: _controllerPasswort,
          decoration: InputDecoration(labelText: "Passwort"),
          obscureText: true,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            final anmeldedaten = {
              "benutzername": _controllerBenutzername.text,
              "passwort": _controllerPasswort.text,
            };
            if (_controllerBenutzername.text.isNotEmpty &&
                _controllerPasswort.text.isNotEmpty) {
              ws.senden("anmeldung", jsonEncode(anmeldedaten));
            }
          },
          child: Text("Anmelden"),
        ),
      ],
    );
  }
}
