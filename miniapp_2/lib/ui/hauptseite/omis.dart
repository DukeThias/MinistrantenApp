import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';

class OmiSeite extends StatefulWidget {
  @override
  _OmiSeiteState createState() => _OmiSeiteState();
}

class _OmiSeiteState extends State<OmiSeite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),

      appBar: AppBar(title: Text("OMis")),
      body: Center(child: Text("Für Omis")),
    );
  }
}
