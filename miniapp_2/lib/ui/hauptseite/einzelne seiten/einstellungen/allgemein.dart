import 'package:flutter/material.dart';
import 'package:miniapp_2/services/datenspeichern.dart';
import '../../../../logik/theme_logik.dart';
import 'package:provider/provider.dart';
import '../../../../logik/globals.dart';

class AllgemeineEinstellungenSeite extends StatefulWidget {
  const AllgemeineEinstellungenSeite({super.key});

  @override
  _AllgemeineEinstellungenSeiteState createState() =>
      _AllgemeineEinstellungenSeiteState();
}

class _AllgemeineEinstellungenSeiteState
    extends State<AllgemeineEinstellungenSeite> {
  int _spracheTapCounter = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final globals = context.watch<Globals>();

    return Scaffold(
      appBar: AppBar(title: Text('Allgemeine Einstellungen')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Sprache'),
            subtitle: Text('Deutsch'),
            onTap: () {
              _spracheTapCounter++;
              if (_spracheTapCounter >= 5) {
                globals.set("specialgraphics", true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('🌟 Spezialgrafiken aktiviert!')),
                );
                saveJson("settings", {"specialgraphics": true});
                _spracheTapCounter = 0; // optional zurücksetzen
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Kommt noch (vielleicht).')),
                );
              }
            },
          ),

          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Darstellung'),
            subtitle: Text('Dark/Light Mode'),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),

          if (globals.get("specialgraphics") ?? false)
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Spezialgrafiken'),
              subtitle: Text(
                globals.get("specialgraphics") ? 'Aktiviert' : 'Deaktiviert',
              ),
              onTap: () {
                globals.set("specialgraphics", !globals.get("specialgraphics"));
                saveJson("settings", {
                  "specialgraphics": globals.get("specialgraphics"),
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Spezialgrafiken ${globals.get("specialgraphics") ? "aktiviert" : "deaktiviert"}',
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
