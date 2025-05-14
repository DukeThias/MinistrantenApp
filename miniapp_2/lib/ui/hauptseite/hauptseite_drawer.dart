import 'package:flutter/material.dart';
import 'package:miniapp_2/services/datenspeichern.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import 'package:provider/provider.dart';
import '../../logik/globals.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(globals.get("anmeldename")),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://www.laupheim.de/fileadmin/Dateien/Bilder/Freizeit_und_Kultur/Tourismus/StPeterPaul_IV.jpg',
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () {
              // Logik für Einstellungen
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Hilfe"),
            onTap: () {
              // Logik für Hilfe
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Informationen"),
            onTap: () {
              // Logik für Informationen
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Abmelden"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Abmelden"),
                    content: Text("Möchten Sie sich wirklich abmelden?"),
                    actions: [
                      TextButton(
                        child: Text("Ja"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          globals.set("angemeldet", false);
                          globals.set("anmeldename", "");
                          globals.set("passwort", "");
                          globals.set("angemeldetbleiben", "false");
                          deleteFile("anmeldedaten");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Anmeldeseite(),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        child: Text("Nein"),
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
    );
  }
}
