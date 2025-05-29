import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/einstellungen/passwort_%C3%A4ndern.dart';
import 'package:provider/provider.dart';
import '../../../../services/datenspeichern.dart';
import '../../../anmeldeseite.dart';

class ProfilEinstellungenSeite extends StatelessWidget {
  const ProfilEinstellungenSeite({super.key});

  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    return Scaffold(
      appBar: AppBar(title: Text('Profil Einstellungen')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Icon(Icons.email),
            title: Text('E-Mail ändern'),
            onTap: () {
              // Handle email change
            },
          ),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Passwort ändern'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswortAendernSeite()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Abmelden'),
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
                          deleteJson("anmeldedaten");
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
