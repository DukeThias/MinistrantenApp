import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';
import '../../logik/globals.dart';
import 'package:provider/provider.dart';
import 'home_termin_karte.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    final termine =
        List<Map<String, dynamic>>.from(
            globals.get("termine"),
          ).where((t) => t["Start"] != null).toList()
          // .where((t) => t["Teilnehmer"].contains(globals.get("self")["Id"]))
          // .toList()
          ..sort(
            (a, b) => DateTime.parse(
              a["Start"],
            ).compareTo(DateTime.parse(b["Start"])),
          );

    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(title: Text("Home")),
      body: ListView.builder(
        itemCount: termine.length,
        itemBuilder: (context, index) {
          final termin = termine[index];
          print("Termin: $termin");
          return TerminKarte(termin: termin);
        },
      ),
    );
  }
}
