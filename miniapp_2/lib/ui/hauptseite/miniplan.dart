import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';

class Miniplan extends StatefulWidget {
  @override
  _MiniplanState createState() => _MiniplanState();
}

class _MiniplanState extends State<Miniplan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),

      appBar: AppBar(title: Text("Miniplan")),
      body: Center(child: Text("Hier ist der Miniplan")),
    );
  }
}
