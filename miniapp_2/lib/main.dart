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
import '../logik/theme_logik.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool angemeldetbleiben = false;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String uniqheId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    Future.microtask(() {
      final ws = Provider.of<Websocketverbindung>(context, listen: false);
      if (!ws.verbunden) {
        ws.verbinde("ws://192.168.2.226:5205/ws?id=$uniqheId");
      }
    });

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: angemeldetbleiben ? Hauptseite() : Anmeldeseite(),
    );
  }
}
