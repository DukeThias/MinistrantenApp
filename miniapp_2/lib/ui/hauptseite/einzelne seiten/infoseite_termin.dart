import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:miniapp_2/logik/theme_logik.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/tausch_initialisieren.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/uploadhtml.dart';
import 'package:provider/provider.dart';

class InfoSeiteTermin extends StatelessWidget {
  final Map<String, dynamic> termin;
  const InfoSeiteTermin({super.key, required this.termin});

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEEE, dd. MMMM yyyy – HH:mm', 'de_DE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final title = termin["Name"] ?? "Kein Titel";
    final beschreibung = termin["Beschreibung"] ?? "Keine Beschreibung";
    final ort = termin["Ort"] ?? "Unbekannter Ort";
    final start = termin["Start"] ?? DateTime.now().toIso8601String();
    final teilnehmer = termin["Teilnehmer"] ?? [];
    final bool alle = termin["alle"] ?? false;
    final globals = context.watch<Globals>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Oben: Haupttitel & Datum
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(),
                    _InfoRow(
                      icon: Icons.date_range,
                      label: "Datum",
                      value: formatDate(start),
                    ),

                    Divider(),

                    // Ort
                    _InfoRow(icon: Icons.place, label: "Ort", value: ort),
                    const SizedBox(height: 10),

                    Divider(),

                    // Teilnehmer
                    if (teilnehmer is List && teilnehmer.isNotEmpty)
                      _InfoRow(
                        icon: Icons.group,
                        label: "Teilnehmer",
                        value:
                            "\n" +
                            getMinistrantenNamen(
                              globals.get("ministranten"),
                              teilnehmer,
                            )!.join("\n"),
                      )
                    else
                      _InfoRow(
                        icon: Icons.group_outlined,
                        label: "Teilnehmer",
                        value: alle ? "Alle" : "Keine Teilnehmer",
                      ),

                    const SizedBox(height: 10),

                    Divider(),

                    // Beschreibung
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 6),
                      child: Text(
                        "Beschreibung",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(beschreibung),
                    Divider(),
                    const SizedBox(height: 24),

                    // Button: Termin tauschen
                    //nur anzeigen, wenn nutzer in termin
                    if (termin["Teilnehmer"].any(
                      (t) => t["MinistrantId"] == globals.get("self")["Id"],
                    ))
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => terminTauschen(context, termin),
                          icon: const Icon(
                            Icons.swap_horiz,
                            size: 30,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Termin tauschen ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(120),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: "$label: ",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

List? getMinistrantenNamen(
  List<dynamic> ministranten,
  List<dynamic> teilnehmer,
) {
  final teilnehmerIds = teilnehmer.map((t) => t['MinistrantId']).toSet();

  final namen =
      ministranten
          .where((m) => teilnehmerIds.contains(m['Id']))
          .map((m) => "${m['Vorname']} ${m['Name']}")
          .toList();

  return namen;
}

void terminTauschen(BuildContext context, termin) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TauschInitialisieren(termin: termin),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Termin tauschen Funktion ist noch nicht implementiert."),
    ),
  );
}
