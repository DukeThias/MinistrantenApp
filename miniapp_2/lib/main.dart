import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logik/WebSocketLogik.dart';
import 'ui/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => Websocketlogik(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Provider Example', home: HomePage());
  }
}
