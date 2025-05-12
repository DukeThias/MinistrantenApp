import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite.dart';
import '../services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../logik/globals.dart';

class Anmeldeseite extends StatefulWidget {
  @override
  _AnmeldeseiteState createState() => _AnmeldeseiteState();
}

class _AnmeldeseiteState extends State<Anmeldeseite> {
  late String uniqheId;

  @override
  void initState() {
    super.initState();
    uniqheId = Uuid().v4();
    Globals().variablenInitiieren();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ws = context.read<Websocketverbindung>();
      if (!ws.verbunden) {
        ws.verbinde("ws://localhost:5205/ws?id=$uniqheId");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Login"),
            Icon(Icons.circle, color: ws.verbunden ? Colors.green : Colors.red),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Hauptseite()),
                );
              },
              child: Text("Anmelden"),
            ),
          ],
        ),
      ),
      body: Center(child: Text("anmelden")),
    );
  }
}
