import 'package:flutter/material.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:miniapp_2/ui/ladebildschirm.dart';
import 'package:provider/provider.dart';
import 'logik/WebSocketLogik.dart';
import 'ui/homepage.dart';
import 'ui/ladebildschirm.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Websocketverbindung(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Provider Example', home: Ladebildschirm());
  }
}
