import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/einstellungen/profil.dart';
import 'einstellungen/allgemein.dart';

class EinstellungenHauptseite extends StatelessWidget {
  const EinstellungenHauptseite({super.key});

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilEinstellungenSeite(),
                ),
              );
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
