import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'termine_bearbeiten.dart';
import 'package:intl/intl.dart';
import 'package:miniapp_2/logik/theme_logik.dart';

class TermineVerwaltenOmis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globals = context.read<Globals>();
    final termine = List<Map<String, dynamic>>.from(globals.get("termine"));

    termine.sort((a, b) {
      final DateTime startA = DateTime.parse(a["Start"]);
      final DateTime startB = DateTime.parse(b["Start"]);
      return startA.compareTo(startB);
    });

    final Map<String, List<Map<String, dynamic>>> gruppierteTermine = {};

    for (var termin in termine) {
      final DateTime start = DateTime.parse(termin["Start"]);
      final String gruppe = _getDatumGruppe(start);
      gruppierteTermine.putIfAbsent(gruppe, () => []).add(termin);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Termine Verwalten')),
      body: ListView(
        children:
            gruppierteTermine.entries.map((eintrag) {
              return _buildGruppe(eintrag.key, eintrag.value, context, globals);
            }).toList(),
      ),
    );
  }

  String _getDatumGruppe(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(Duration(days: 1));
    final endOfWeek = today.add(Duration(days: 7));

    if (DateUtils.isSameDay(date, today)) return "Heute";
    if (DateUtils.isSameDay(date, tomorrow)) return "Morgen";
    if (date.isBefore(endOfWeek)) return "Diese Woche";
    return DateFormat('MMMM yyyy', 'de').format(date);
  }

  Widget _buildGruppe(
    String titel,
    List<Map<String, dynamic>> termine,
    BuildContext context,
    Globals globals,
  ) {
    final theme = context.watch<ThemeProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color:
              theme.themeMode == ThemeMode.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade800,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            titel,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
                  theme.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
            ),
          ),
        ),
        ...termine.map((termin) {
          final DateTime startZeit = DateTime.parse(termin["Start"]);
          final String uhrzeit = DateFormat(
            'dd.MM.yyyy, HH:mm',
          ).format(startZeit);

          return ListTile(
            title: Text(termin['Name'] ?? 'Kein Titel'),
            subtitle: Text(uhrzeit),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              final ministranten = globals.get("ministranten");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TermineBearbeiten(
                        termin: termin,
                        ministranten: ministranten,
                      ),
                ),
              );
            },
          );
        }).toList(),
      ],
    );
  }
}
