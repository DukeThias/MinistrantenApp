import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import 'package:miniapp_2/logik/verbindungsstatus.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import 'package:miniapp_2/ui/hauptseite.dart';
import '../logik/globals.dart';
import 'package:provider/provider.dart';
import 'services/datenspeichern.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/date_symbol_data_local.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool angemeldetbleiben = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting("de_DE", null);
  Map<String, dynamic>? anmeldedaten = await readJsonFromFile("anmeldedaten");

  angemeldetbleiben =
      anmeldedaten?["angemeldetbleiben"].toLowerCase() == "true";
  if (angemeldetbleiben) {
    if (angemeldetbleiben) {
      String? passwort = anmeldedaten?["passwort"];
      String? benutzername = anmeldedaten?["benutzername"];
      if (benutzername != null && passwort != null) {}
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Verbindungsstatus()),
        ChangeNotifierProvider(create: (_) => WebSocketLogik()),
        ChangeNotifierProvider(create: (_) => Websocketverbindung()),
        ChangeNotifierProvider(create: (_) => Globals()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String uniqheId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      final ws = Provider.of<Websocketverbindung>(context, listen: false);
      if (!ws.verbunden) {
        ws.verbinde("ws://192.168.2.226:5205/ws?id=$uniqheId");
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: angemeldetbleiben ? Hauptseite() : Anmeldeseite(),
    );
  }
}
