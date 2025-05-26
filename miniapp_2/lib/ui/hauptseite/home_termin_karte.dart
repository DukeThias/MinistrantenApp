import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'einzelne seiten/infoseite_termin.dart';
import 'package:provider/provider.dart';
import '../../logik/globals.dart';
import '../../logik/theme_logik.dart';

class TerminKarte extends StatelessWidget {
  final Map<String, dynamic> termin;

  TerminKarte({required this.termin});

  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    final theme = context.watch<ThemeProvider>();
    final DateTime startZeit = DateTime.parse(termin["Start"]);
    final String wochentag = DateFormat.EEEE(
      'de_DE',
    ).format(startZeit); // z.B. Sonntag
    final String datum = DateFormat(
      'dd.MM.yyyy',
    ).format(startZeit); // 20.07.2025
    final String uhrzeit = DateFormat('HH:mm').format(startZeit); // 09:00

    return Card(
      elevation: globals.get("specialgraphics") ? 10 : 2,
      shadowColor:
          globals.get("specialgraphics")
              ? Colors.red
              : (theme.themeMode == ThemeMode.dark
                  ? const Color.fromARGB(133, 129, 129, 129)
                  : const Color.fromARGB(133, 95, 95, 95)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        // side: BorderSide(
        //   color: Colors.black, // Farbe der Umrandung
        //   width: 1, // Dicke der Linie
        // ),
      ),

      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          // Kopfzeile
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoSeiteTermin(termin: termin),
                ),
              );
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(wochentag, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(datum, style: TextStyle(fontSize: 12)),
              ],
            ),
            title: Text(
              termin["Name"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(termin["Ort"]),
            trailing: Icon(Icons.chevron_right),
          ),

          Divider(),

          // Zusatzinfos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Beginn", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(
                      uhrzeit,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                VerticalDivider(width: 1),
                Column(
                  children: [
                    Text("Teilnehmer", style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 4),
                    Text(
                      termin["Teilnehmer"].join(", ") ?? "-",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Beschreibung (optional)
          if ((termin["Beschreibung"] ?? "").isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  termin["Beschreibung"],
                  // style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
