import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoSeiteTermin extends StatelessWidget {
  final Map<String, dynamic> termin;
  const InfoSeiteTermin({super.key, required this.termin});

  String formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return DateFormat('EEEE, dd. MMMM yyyy – HH:mm', 'de_DE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final title = termin["Name"] ?? "Kein Titel";
    final beschreibung = termin["Beschreibung"] ?? "Keine Beschreibung";
    final ort = termin["Ort"] ?? "Unbekannter Ort";
    final start = termin["Start"] ?? DateTime.now().toIso8601String();
    final teilnehmer = termin["Teilnehmer"] ?? [];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: primaryColor.withOpacity(0.87),
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
                        Icon(
                          Icons.calendar_today_rounded,
                          color: primaryColor,
                          size: 30,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatDate(start),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                        value: teilnehmer.join(", "),
                      )
                    else
                      _InfoRow(
                        icon: Icons.group_outlined,
                        label: "Teilnehmer",
                        value: "Keine Teilnehmer angegeben",
                      ),
                    const SizedBox(height: 10),

                    Divider(),

                    // Beschreibung
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 6),
                      child: Text(
                        "Beschreibung",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(beschreibung, style: theme.textTheme.bodyMedium),
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
