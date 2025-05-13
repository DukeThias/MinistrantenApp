import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import 'package:miniapp_2/ui/hauptseite.dart';
import '../logik/globals.dart';
import 'package:provider/provider.dart';
import 'services/datenspeichern.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  Globals().set(
    "angemeldetbleiben",
    await readBoolFromFile("angemeldetbleiben"),
  );
  if (Globals().get("angemeldetbleiben") != null) {
    if (Globals().get("angemeldetbleiben")) {
      String? benutzername = await readStringFromFile("benutzername");
      String? passwort = await readStringFromFile("passwort");
      if (benutzername != null && passwort != null) {
        Globals().set("benutzername", benutzername);
        Globals().set("passwort", passwort);
      }
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketLogik()),
        ChangeNotifierProvider(create: (_) => Websocketverbindung()),
        ChangeNotifierProvider(create: (_) => Globals()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home:
          Globals().get("angemeldetbleiben") == true
              ? Hauptseite()
              : Anmeldeseite(),
    );
  }
}
