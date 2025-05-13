import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import '../logik/globals.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
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
    return MaterialApp(navigatorKey: navigatorKey, home: Anmeldeseite());
  }
}
