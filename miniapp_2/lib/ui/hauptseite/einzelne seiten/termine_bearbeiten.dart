import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TermineBearbeiten extends StatefulWidget {
  final Map<String, dynamic> termin;
  final List<dynamic>
  ministranten; // Aus globals holen und beim Aufruf übergeben

  const TermineBearbeiten({
    Key? key,
    required this.termin,
    required this.ministranten,
  }) : super(key: key);

  @override
  State<TermineBearbeiten> createState() => _TermineBearbeitenState();
}

class _TermineBearbeitenState extends State<TermineBearbeiten> {
  late TextEditingController _nameController;
  late TextEditingController _beschreibungController;
  late TextEditingController _ortController;
  late DateTime _startZeit;
  late bool _alle;
  late List<int> _ausgewaehlteTeilnehmer;
  String _suchbegriff = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.termin['Name']);
    _beschreibungController = TextEditingController(
      text: widget.termin['Beschreibung'],
    );
    _ortController = TextEditingController(text: widget.termin['Ort']);
    _startZeit = DateTime.parse(widget.termin['Start']);
    _alle = widget.termin['alle'] ?? false;
    _ausgewaehlteTeilnehmer = List<int>.from(widget.termin['Teilehmer'] ?? []);
  }

  void _terminErstellen() {
    final neuerTermin = {
      "Id": widget.termin['Id'],
      "Name": _nameController.text,
      "Beschreibung": _beschreibungController.text,
      "Ort": _ortController.text,
      "Start": _startZeit.toIso8601String(),
      "alle": _alle,
      "Teilnehmer": _alle ? [] : _ausgewaehlteTeilnehmer,
      "GemeindeID": widget.termin['GemeindeID'],
    };

    print('Neuer Termin: $neuerTermin');
    // TODO: sendeLogik(neuerTermin);
  }

  @override
  Widget build(BuildContext context) {
    final ministrantenGefiltert =
        widget.ministranten
            .where(
              (m) =>
                  m['Vorname'].toLowerCase().contains(
                    _suchbegriff.toLowerCase(),
                  ) ||
                  m['Name'].toLowerCase().contains(_suchbegriff.toLowerCase()),
            )
            .toList()
          ..sort(
            (a, b) => ('${a['Vorname']} ${a['Name']}').compareTo(
              '${b['Vorname']} ${b['Name']}',
            ),
          );

    return Scaffold(
      appBar: AppBar(title: const Text('Termin bearbeiten')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: _beschreibungController,
              decoration: const InputDecoration(labelText: 'Beschreibung'),
            ),
            TextField(
              controller: _ortController,
              decoration: const InputDecoration(labelText: 'Ort'),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(
                'Startzeit: ${DateFormat.yMd().add_Hm().format(_startZeit)}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startZeit,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startZeit),
                  );
                  if (time != null) {
                    setState(() {
                      _startZeit = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            SwitchListTile(
              title: const Text('Alle eingeladen?'),
              value: _alle,
              onChanged: (value) => setState(() => _alle = value),
            ),
            if (!_alle) ...[
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Teilnehmer suchen...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(() => _suchbegriff = value),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    _ausgewaehlteTeilnehmer.map((id) {
                      final teilnehmer = widget.ministranten.firstWhere(
                        (m) => m['Id'] == id,
                      );
                      final name =
                          '${teilnehmer['Vorname']} ${teilnehmer['Name']}';
                      return Chip(
                        label: Text(name),
                        onDeleted: () {
                          setState(() => _ausgewaehlteTeilnehmer.remove(id));
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 300, // begrenzte Höhe für lange Listen
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: ministrantenGefiltert.length,
                    itemBuilder: (context, index) {
                      final m = ministrantenGefiltert[index];
                      final id = m['Id'];
                      final name = '${m['Vorname']} ${m['Name']}';
                      final ausgewaehlt = _ausgewaehlteTeilnehmer.contains(id);
                      return CheckboxListTile(
                        title: Text(name),
                        value: ausgewaehlt,
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _ausgewaehlteTeilnehmer.add(id);
                            } else {
                              _ausgewaehlteTeilnehmer.remove(id);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Termin aktualisieren'),
              onPressed: _terminErstellen,
            ),
          ],
        ),
      ),
    );
  }
}
