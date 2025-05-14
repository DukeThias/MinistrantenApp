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

class Hauptseite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    final globals = context.watch<Globals>();

    // Noch nicht initialisiert? Dann Ladeanzeige anzeigen
    if (!globals.initiert) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final int index = globals.get("hauptseite_index") ?? 0;

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
      body: <Widget>[Home(), Miniplan(), Chats(), Boerse(), OmiSeite()][index],
    );
  }
}
