import 'package:flutter/material.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:miniapp_2/ui/anmeldeseite.dart';
import '../logik/globals.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
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
    return MaterialApp(title: 'Provider Example', home: Anmeldeseite());
  }
}
