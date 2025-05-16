import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import '../logik/globals.dart';
import 'Hauptseite_logik.dart';
import 'package:miniapp_2/ui/hauptseite/home.dart';
import 'package:miniapp_2/ui/hauptseite/miniplan.dart';
import 'package:miniapp_2/ui/hauptseite/chats.dart';
import 'package:miniapp_2/ui/hauptseite/boerse.dart';
import 'package:miniapp_2/ui/hauptseite/omis.dart';
import 'hauptseite/hauptseite_drawer.dart';
import '../logik/verbindungsstatus.dart';

class Hauptseite extends StatefulWidget {
  @override
  State<Hauptseite> createState() => _HauptseiteState();
}

class _HauptseiteState extends State<Hauptseite> {
  bool vorherVerbunden = true;

  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    final globals = context.watch<Globals>();
    final status = context.watch<Verbindungsstatus>();

    if (!globals.initiert) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int index = globals.get("hauptseite_index") ?? 0;
    if (ws.verbunden && !vorherVerbunden) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<Verbindungsstatus>().triggerOnlineHinweis();
      });
    }
    vorherVerbunden = ws.verbunden;

    return Scaffold(
      drawer: drawer(),
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.red,
        destinations: destinations(globals.get("rollen")),
        onDestinationSelected: (int index) {
          globals.set("hauptseite_index", index);
        },
        selectedIndex: index,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child:
                <Widget>[
                  Home(),
                  Miniplan(),
                  Chats(),
                  Boerse(),
                  OmiSeite(),
                ][index],
          ),
          if (!ws.verbunden || status.zeigeWiederVerbunden)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: ws.verbunden ? Colors.green : Colors.red,
                child: Text(
                  ws.verbunden
                      ? "Wieder verbunden"
                      : "Verbindung getrennt (Daten könnten abweichen)",
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
