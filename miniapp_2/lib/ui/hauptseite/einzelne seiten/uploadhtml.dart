import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/infoseite_termin.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'uploadhtmlding.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';

class UploadHtmlPage extends StatefulWidget {
  const UploadHtmlPage({super.key});

  @override
  _UploadHtmlPageState createState() => _UploadHtmlPageState();
}

class _UploadHtmlPageState extends State<UploadHtmlPage> {
  List<Termin> termine = [];
  String status = '';
  bool isLoading = false;
  String htmlString = "";

  // Annahme: getFileContent kommt aus file_reader.dart

  Future<void> pickAndParseFile() async {
    setState(() {
      isLoading = true;
      status = 'Lade Datei...';
    });

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['html'],
    );

    if (result != null) {
      final file = result.files.single;
      String? content;
      if (kIsWeb) {
        // Web: Datei-Inhalt als Bytes verfügbar
        final bytes = file.bytes;
        if (bytes == null) {
          setState(() {
            isLoading = false;
            status = "Datei konnte nicht gelesen werden.";
          });
          return;
        }
        content = String.fromCharCodes(bytes);
      } else {
        // Native: Datei-Inhalt über Pfad laden (brauchst NICHT importieren!)
        final path = file.path;
        if (path == null) {
          setState(() {
            isLoading = false;
            status = "Datei konnte nicht gelesen werden.";
          });
          return;
        }
        // Dynamisches Laden von 'dart:io'
        content = await readFileNative(path);
      }

      final parsedTermine = extractTermine(content);
      htmlString = content;
      setState(() {
        termine = parsedTermine;
        status = 'Datei geladen: ${file.name}';
        isLoading = false;
      });
    } else {
      setState(() {
        status = 'Keine Datei ausgewählt';
        isLoading = false;
      });
    }
  }

  List<Termin> extractTermine(String html) {
    final rows = RegExp(r'<tr>(.*?)<\/tr>', dotAll: true).allMatches(html);
    List<Termin> termine = [];
    Termin? current;

    for (final rowMatch in rows) {
      final rowHtml = rowMatch.group(1)!;
      final cells =
          RegExp(
            r'<td.*?>(.*?)<\/td>',
            dotAll: true,
          ).allMatches(rowHtml).map((m) => m.group(1)!.trim()).toList();

      if (cells.isEmpty) continue;

      final firstCell = cells.first;

      if (RegExp(r'^\w{2}\. \d{2}\.\d{2}\.\d{4}').hasMatch(firstCell)) {
        final match = RegExp(
          r'(\d{2}\.\d{2}\.\d{4}) (\d{2}:\d{2}).*?, ([^<]+)',
        ).firstMatch(firstCell);
        if (match != null) {
          final datum = DateFormat(
            'dd.MM.yyyy HH:mm',
          ).parse('${match[1]} ${match[2]}');
          final ort = match[3]!;
          final titel = firstCell;

          current = Termin(
            titel: titel,
            ort: ort,
            date: datum,
            beschreibung: '',
            teilnehmer: [],
          );
          termine.add(current);
        }
      }

      if (current != null && cells.length >= 3) {
        final teilnehmer = cells.skip(2).where((c) => c.isNotEmpty).toList();
        current.teilnehmer.addAll(teilnehmer);
      }
    }

    termine.sort((a, b) => a.date.compareTo(b.date));
    return termine;
  }

  Widget buildTerminCard(Termin termin) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.event, color: Colors.indigo),
        title: Text(
          DateFormat('EEEE, dd.MM.yyyy – HH:mm', 'de').format(termin.date),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(termin.ort),
            if (termin.teilnehmer.isNotEmpty)
              Text(
                'Teilnehmer: ${termin.teilnehmer.join(', ')}',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => InfoSeiteTermin(termin: termin.toMap()),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HTML-Termine hochladen'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                termine.clear();
                status = '';
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: pickAndParseFile,
              icon: Icon(Icons.upload_file),
              label: Text('HTML-Datei auswählen'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            SizedBox(height: 12),
            if (isLoading)
              CircularProgressIndicator()
            else
              Text(status, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 16),
            Expanded(
              child:
                  termine.isEmpty
                      ? Center(child: Text('Keine Termine vorhanden.'))
                      : ListView.builder(
                        itemCount: termine.length,
                        itemBuilder:
                            (context, index) => buildTerminCard(termine[index]),
                      ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed:
                  termine.isNotEmpty
                      ? () {
                        final ws = Provider.of<Websocketverbindung>(
                          context,
                          listen: false,
                        );
                        ws.sendHtmlPlanFile('termine.html', htmlString);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Termine wurden gesendet!')),
                        );
                        Navigator.of(context).pop();
                      }
                      : null,
              icon: Icon(Icons.send),
              label: Text('Senden'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Termin {
  final String titel;
  final String ort;
  final DateTime date;
  final String beschreibung;
  final List<String> teilnehmer;

  Termin({
    required this.titel,
    required this.ort,
    required this.date,
    required this.beschreibung,
    required this.teilnehmer,
  });

  Map<String, dynamic> toMap() {
    return {
      'Name': titel,
      'Ort': ort,
      'Beschreibung': beschreibung,
      'Teilnehmer': teilnehmer,
      'Start': date.toIso8601String(), // ISO String als Standard-Darstellung
    };
  }
}
