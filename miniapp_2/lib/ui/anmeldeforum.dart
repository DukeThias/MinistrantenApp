import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import 'dart:convert';
import '../services/datenspeichern.dart';

class AnmeldeFormular extends StatefulWidget {
  @override
  _AnmeldeFormularState createState() => _AnmeldeFormularState();
}

class _AnmeldeFormularState extends State<AnmeldeFormular> {
  final TextEditingController _controllerBenutzername = TextEditingController();
  final TextEditingController _controllerPasswort = TextEditingController();
  bool angemeldetbleiben = true;
  bool _isObscured = true;
  @override
  void dispose() {
    _controllerBenutzername.dispose();
    _controllerPasswort.dispose();
    super.dispose();
  }

  void _showNameInputDialog(
    BuildContext context,
    String gemeinde,
    Websocketverbindung ws,
  ) {
    final TextEditingController vornameController = TextEditingController();
    final TextEditingController nachnameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Neuer Account erstellen"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: vornameController,
                decoration: InputDecoration(labelText: "Vorname"),
              ),
              TextField(
                controller: nachnameController,
                decoration: InputDecoration(labelText: "Nachname"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Erstellen"),
              onPressed: () {
                final vorname = vornameController.text;
                final nachname = nachnameController.text;

                if (vorname.isEmpty || nachname.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Bitte Vor- und Nachname eingeben."),
                    ),
                  );
                } else {
                  final daten = {
                    "gemeinde": gemeinde,
                    "vorname": vorname,
                    "nachname": nachname,
                  };
                  ws.senden("neuer_account", jsonEncode(daten));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
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
              if (angemeldetbleiben) {
                saveStringToFile("benutzername", _controllerBenutzername.text);
                globals.set("benutzername", _controllerBenutzername.text);
                saveStringToFile("passwort", _controllerPasswort.text);
                globals.set("passwort", _controllerPasswort.text);
                saveBoolToFile("angemeldetbleiben", true);
                globals.set("angemeldetbleiben", true);
              } else {
                deleteFile("benutzername");
                deleteFile("passwort");
                deleteFile("angemeldetbleiben");
                globals.set("angemeldetbleiben", false);
              }
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
                                    Navigator.of(context).pop();

                                    _showNameInputDialog(context, gemeinde, ws);
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
