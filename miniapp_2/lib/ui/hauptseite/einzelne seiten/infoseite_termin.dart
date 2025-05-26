import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoSeiteTermin extends StatelessWidget {
  final Map<String, dynamic> termin;

  const InfoSeiteTermin({Key? key, required this.termin}) : super(key: key);

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEEE, dd. MMMM yyyy – HH:mm', 'de_DE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final title = termin["Name"] ?? "Kein Titel";
    final beschreibung = termin["Beschreibung"] ?? "Keine Beschreibung";
    final ort = termin["Ort"] ?? "Unbekannter Ort";
    final start = termin["Start"] ?? DateTime.now().toIso8601String();
    final teilnehmer = termin["Teilnehmer"] ?? "Nicht angegeben";

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),

                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Datum & Uhrzeit'),
                  subtitle: Text(formatDate(start)),
                ),

                ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Ort'),
                  subtitle: Text(ort),
                ),

                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Teilnehmer'),
                  subtitle: Text(
                    teilnehmer.isNotEmpty
                        ? teilnehmer.join(", ")
                        : "Keine Teilnehmer angegeben",
                  ),
                ),

                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Beschreibung'),
                  subtitle: Text(beschreibung),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
