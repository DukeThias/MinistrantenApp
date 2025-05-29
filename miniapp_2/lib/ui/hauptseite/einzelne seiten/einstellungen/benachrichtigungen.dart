import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart'; // Ensure Provider is imported

class BenachrichtigungEinstellungenSeite extends StatefulWidget {
  @override
  _BenachrichtigungEinstellungenSeiteState createState() =>
      _BenachrichtigungEinstellungenSeiteState();
}

class _BenachrichtigungEinstellungenSeiteState
    extends State<BenachrichtigungEinstellungenSeite> {
  bool pushBenachrichtigung = true;
  bool emailBenachrichtigung = false;
  bool newsletter = false;

  void _speichern(BuildContext context) {
    context.read<Websocketverbindung>().senden(
      "benachrichtigungsEinstellungen",
      jsonEncode({
        "push": pushBenachrichtigung,
        "email": emailBenachrichtigung,
        "newsletter": newsletter,
      }),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Benachrichtigungseinstellungen gespeichert!')),
    );
  }

  @override
  void dispose() {
    _speichern(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final globals = context.watch<Globals>(); // Optional für Provider

    return Scaffold(
      appBar: AppBar(
        title: Text('Benachrichtigungseinstellungen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: pushBenachrichtigung,
            onChanged: (val) => setState(() => pushBenachrichtigung = val),
            title: Text('Push-Benachrichtigungen'),
            subtitle: Text('Direkte Benachrichtigungen aufs Gerät'),
            secondary: Icon(Icons.notifications_active),
          ),
          SwitchListTile(
            value: emailBenachrichtigung,
            onChanged: (val) => setState(() => emailBenachrichtigung = val),
            title: Text('E-Mail-Benachrichtigungen'),
            subtitle: Text('Benachrichtigungen per E-Mail'),
            secondary: Icon(Icons.email),
          ),

          SwitchListTile(
            value: newsletter,
            onChanged: (val) => setState(() => newsletter = val),
            title: Text('Newsletter'),
            subtitle: Text('Regelmäßige Infos und Tipps'),
            secondary: Icon(Icons.mark_email_unread),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _speichern(context);
            },
            icon: Icon(Icons.save),
            label: Text('Einstellungen speichern'),
          ),
        ],
      ),
    );
  }
}
