import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:miniapp_2/logik/WebSocketLogik.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Provider Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('You have pushed the button this many times:')],
        ),
      ),
    );
  }
}
