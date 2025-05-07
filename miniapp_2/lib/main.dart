import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logik/counter_provider.dart';
import 'ui/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => CounterProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Provider Example', home: HomePage());
  }
}
