import 'package:flutter/material.dart';
import 'einstellungen/allgemein.dart';

class EinstellungenHauptseite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Einstellungen')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Allgemein"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllgemeineEinstellungenSeite(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              // Navigate to Profil settings
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Benachrichtigungen'),
            onTap: () {
              // Navigate to Benachrichtigungen settings
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Datenschutz'),
            onTap: () {
              // Navigate to Datenschutz settings
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Über die App'),
            onTap: () {
              // Navigate to Über die App page
            },
          ),
        ],
      ),
    );
  }
}
