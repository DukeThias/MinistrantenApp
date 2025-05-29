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
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_messaging.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
bool angemeldetbleiben = false;
Map<String, dynamic>? gespeicherteAnmeldedaten;
bool specialgraphics = false;
String fcmToken = "";
String url = "192.168.178.109";

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.red,
  scaffoldBackgroundColor: Colors.white, //Lukas war hier UwU
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF5865F2), // Discord-Blau
  scaffoldBackgroundColor: const Color(0xFF36393F), // Haupt-Hintergrund
  cardColor: const Color(0xFF2F3136), // Für Cards/Container
  canvasColor: const Color(0xFF36393F),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF23272A), // Dunklere AppBar
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF5865F2),
    secondary: Color(0xFF5865F2),
    background: Color(0xFF36393F),
    surface: Color(0xFF2F3136),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Color(0xFFB9BBBE)), // Sekundärtext
    bodySmall: TextStyle(color: Color(0xFFB9BBBE)),
    titleLarge: TextStyle(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Color(0xFFB9BBBE)),
  dividerColor: Color(0xFF202225),
  drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF2F3136)),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF5865F2),
    textTheme: ButtonTextTheme.primary,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //für push benachrichtigunen
  await Firebase.initializeApp();
  if (!kIsWeb) {
    fcmToken = await setupPushNotifications();
  }

  final settings = await readJson("settings");
  specialgraphics = settings?["specialgraphics"] ?? false;

  await initializeDateFormatting("de_DE", null);
  gespeicherteAnmeldedaten = await readJson("anmeldedaten");
  angemeldetbleiben = gespeicherteAnmeldedaten?["angemeldetbleiben"] == "true";

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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String uniqheId = Uuid().v4();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ws = Provider.of<Websocketverbindung>(context, listen: false);
      final globals = Provider.of<Globals>(context, listen: false);
      ws.setAnmeldedaten(
        gespeicherteAnmeldedaten?["Username"],
        gespeicherteAnmeldedaten?["Passwort"],
      );
      ws.verbinde("ws://${url}:5205/ws?id=$uniqheId");
      await globals.variablenInitiieren();
      globals.set("specialgraphics", true);
      globals.set("fcmToken", fcmToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

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
