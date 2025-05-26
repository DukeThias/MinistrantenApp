import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';

class HtmlUploadWidget extends StatefulWidget {
  @override
  _HtmlUploadWidgetState createState() => _HtmlUploadWidgetState();
}

class _HtmlUploadWidgetState extends State<HtmlUploadWidget> {
  PlatformFile? selectedFile;
  String status = '';

  Future<void> pickAndSendFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['html'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();

      final websocket = Provider.of<Websocketverbindung>(
        context,
        listen: false,
      );
      websocket.sendHtmlPlanFile(result.files.single.name, content);

      setState(() {
        status = 'Datei gesendet: ${result.files.single.name}';
      });
    } else {
      setState(() {
        status = 'Keine Datei ausgewählt';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: pickAndSendFile,
          child: Text('HTML-Datei auswählen & senden'),
        ),
        if (status.isNotEmpty) Text(status),
      ],
    );
  }
}
