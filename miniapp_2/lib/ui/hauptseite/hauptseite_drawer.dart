import 'package:flutter/material.dart';
import 'package:miniapp_2/services/datenspeichern.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import 'package:provider/provider.dart';
import '../../logik/globals.dart';
import 'einzelne seiten/einstellungen_hauptseite.dart';
import '../../logik/theme_logik.dart';

class drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final globals = context.watch<Globals>();
    final user = globals.get("self");
    final name =
        (user["Vorname"] ?? "Du bist") +
        " " +
        (user["Name"] ??
            "offline, aber angemeldet als: ${globals.get("benutzername")}");
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: ListView(
        children: [
          DrawerHeader(
            child: SizedBox(),
            decoration: BoxDecoration(
              color:
                  themeProvider.themeMode == ThemeMode.dark
                      ? Colors.black
                      : Colors.white,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image:
                    themeProvider.isDarkMode()
                        ? NetworkImage(
                          scale: 0.1,
                          "https://www.se-federsee.de/wp-content/uploads/2018/03/Logo_Mini_negativ_RGB.jpg",
                        )
                        : NetworkImage(
                          scale: 0.1,
                          "https://fachstelle-minis.de/fileadmin/user_upload/Logos/Mini.jpg",
                        ),
              ),
            ),
          ),
          ListTile(
            title: Text(name),
            subtitle: Text(
              "Gemeinde: " +
                  (((globals.get("gemeinden") ?? []).firstWhere(
                        (g) => g["Id"] == user["GemeindeID"],
                        orElse: () => {"Name": "Konnte nicht abgerufen werden"},
                      ))["Name"] ??
                      "Konnte nicht abgerufen werden"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Einstellungen"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EinstellungenHauptseite(),
                ),
              );
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
