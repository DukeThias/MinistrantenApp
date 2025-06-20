import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import '../services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';
import '../logik/globals.dart';
import 'anmeldeforum.dart';

class Anmeldeseite extends StatefulWidget {
  const Anmeldeseite({super.key});

  @override
  _AnmeldeseiteState createState() => _AnmeldeseiteState();
}

class _AnmeldeseiteState extends State<Anmeldeseite> {
  late String uniqheId;

  late WebSocketLogik wsLogik;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [if (ws.verbunden) Text("Ministranten - Anmeldung")],
        ),
      ),
      body: Stack(
        children: [
          if (!ws.verbunden)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Verbindung wird hergestellt..."),
                ],
              ),
            )
          else
            Padding(padding: EdgeInsets.all(16), child: AnmeldeFormular()),
        ],
      ),
    );
  }
}
