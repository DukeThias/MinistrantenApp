import 'package:flutter/material.dart';
import '../../../../logik/theme_logik.dart';
import 'package:provider/provider.dart';

class AllgemeineEinstellungenSeite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Allgemeine Einstellungen')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Sprache'),
            subtitle: Text('Deutsch'),
            onTap: () {
              //snackbar anzeigen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Kommt noch (vielleicht).')),
              );
            },
          ),
          //dark/lightmode
          ListTile(
            leading: Icon(Icons.brightness_6),
            title: Text('Darstellung'),
            subtitle: Text('Dark/Light Mode'),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
