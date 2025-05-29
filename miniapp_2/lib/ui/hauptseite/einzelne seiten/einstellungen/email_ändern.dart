import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';

class EmailAendernSeite extends StatefulWidget {
  @override
  _EmailAendernSeiteState createState() => _EmailAendernSeiteState();
}

class _EmailAendernSeiteState extends State<EmailAendernSeite> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailController = TextEditingController();

  @override
  void dispose() {
    _newEmailController.dispose();
    super.dispose();
  }

  void _changeEmail(Websocketverbindung ws, Globals globals) async {
    if (_formKey.currentState!.validate()) {
      // Nach Passwort fragen (Dialog)
      final TextEditingController passController = TextEditingController();
      final result = await showDialog<String>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Zur Verifizierung bitte Passwort eingeben'),
              content: TextField(
                controller: passController,
                decoration: InputDecoration(labelText: 'Passwort'),
                obscureText: true,
                autofocus: true,
              ),
              actions: [
                TextButton(
                  child: Text('Abbrechen'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: Text('Bestätigen'),
                  onPressed:
                      () => Navigator.of(context).pop(passController.text),
                ),
              ],
            ),
      );
      if (result == null || result.isEmpty) {
        // Abbruch oder keine Eingabe
        return;
      }
      if (result != globals.get('self')["Passwort"]) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Passwort ist falsch.')));
        return;
      }

      // Erfolg, sende per Websocket
      final String oldEmail = globals.get("self")["Email"] ?? '';
      final String username = globals.get("self")["Username"] ?? '';
      ws.senden(
        "emailAendern",
        jsonEncode({
          "benutzername": username,
          "altesEmail": oldEmail,
          "neuesEmail": _newEmailController.text,
        }),
      );
      print("Neue email gesendet");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('E-Mail erfolgreich geändert!')));

      // Opt. zurückgehen
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    final globals = context.watch<Globals>();
    final String oldEmail = globals.get("self")["Email"] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text('E-Mail ändern')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Deine alte E-Mail:\n$oldEmail',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _newEmailController,
                decoration: InputDecoration(labelText: 'Neue E-Mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte neue E-Mail eingeben';
                  }
                  if (value == oldEmail) {
                    return 'Die neue E-Mail ist gleich der alten E-Mail';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Bitte eine gültige E-Mail eingeben';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _changeEmail(ws, globals),
                child: Text('E-Mail ändern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
