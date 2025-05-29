import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';

class Boerse extends StatefulWidget {
  const Boerse({super.key});

  @override
  _BoerseState createState() => _BoerseState();
}

class _BoerseState extends State<Boerse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),

      appBar: AppBar(title: Text("Tauschen")),
      body: Center(child: Text("Hier ist die Seite zum Tauschen")),
    );
  }
}
