import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import 'dart:convert';
import 'package:miniapp_2/services/datenspeichern.dart';

class AnmeldeFormular extends StatefulWidget {
  @override
  _AnmeldeFormularState createState() => _AnmeldeFormularState();
}

class _AnmeldeFormularState extends State<AnmeldeFormular> {
  final TextEditingController _controllerBenutzername = TextEditingController();
  final TextEditingController _controllerPasswort = TextEditingController();
  bool angemeldetbleiben = false;
  bool _isObscured = true;
  @override
  void dispose() {
    _controllerBenutzername.dispose();
    _controllerPasswort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    final globals = context.watch<Globals>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controllerBenutzername,
          decoration: InputDecoration(labelText: "Benutzername"),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controllerPasswort,
                decoration: InputDecoration(labelText: "Passwort"),
                obscureText: _isObscured,
              ),
            ),
            IconButton(
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: angemeldetbleiben,
                  onChanged: (bool? value) {
                    setState(() {
                      angemeldetbleiben = value ?? false;
                    });
                  },
                ),
                Text("Angemeldet bleiben"),
              ],
            ),
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Info"),
                      content: Text(
                        "Diese Option speichert Ihre Anmeldedaten, sodass sie nichtmehr eingegeben werden müssen. Außerdem werden empfangene Daten gespeichert und z.B. der Miniplan kann auch offline angezeigt werden",
                      ),
                      actions: [
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),

        SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {
            final anmeldedaten = {
              "benutzername": _controllerBenutzername.text,
              "passwort": _controllerPasswort.text,
            };
            if (_controllerBenutzername.text.isEmpty ||
                _controllerPasswort.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Bitte Benutzername und Passwort eingeben."),
                ),
              );
            } else {
              ws.senden("anmeldung", jsonEncode(anmeldedaten));
            }
          },
          child: Text("Anmelden"),
        ),
        SizedBox(height: 16),
        TextButton(
          onPressed: () {
            ws.senden("anfrage", "gemeinden");
            showDialog(
              context: context,
              builder: (context) {
                final gemeinden = globals.get("gemeinden");
                return AlertDialog(
                  title: Text("Gemeinden"),
                  content: SingleChildScrollView(
                    child: Column(
                      children:
                          gemeinden == null || gemeinden.isEmpty
                              ? [Text("Bitte warten...")]
                              : gemeinden.map<Widget>((gemeinde) {
                                return ListTile(
                                  title: Text(gemeinde),
                                  onTap: () {
                                    ws.senden("neuer_account", gemeinde);
                                    Navigator.of(context).pop();
                                  },
                                );
                              }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text("Schließen"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text("Noch kein Account?"),
        ),
      ],
    );
  }
}
