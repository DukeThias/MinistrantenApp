import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniapp_2/logik/globals.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';
import 'package:provider/provider.dart';

class TauschInitialisieren extends StatelessWidget {
  final Map<String, dynamic> termin;

  TauschInitialisieren({required this.termin});

  @override
  Widget build(BuildContext context) {
    final globals = context.watch<Globals>();
    final ws = context.watch<Websocketverbindung>();
    final self = globals.get("self");
    final termine = globals.get("termine");
    final ministranten = globals.get("ministranten");

    // Extract the role of the current user in the given termin
    final selfRole =
        termine
            .firstWhere((t) => t['Id'] == termin['Id'])['Teilnehmer']
            .firstWhere(
              (teili) => teili['Id'] == self['Id'],
              orElse: () => null,
            )?['Rolle'];

    // Filter ministranten with the same role
    final sameRoleMinistranten =
        ministranten
            .where(
              (m) =>
                  m['Rolle'].split(",") is List &&
                  m['Rolle'].split(",").contains(selfRole),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Tausch Initialisieren')),
      body: ListView.builder(
        itemCount: sameRoleMinistranten.length,
        itemBuilder: (context, index) {
          final ministrant = sameRoleMinistranten[index];
          return ListTile(
            onTap: () {
              final nachricht = {
                "vonUserId": self["Id"],
                "anUserId": ministrant["Id"],
                "vonTerminId": termin["Id"],
              };
              ws.senden("tauschenInitialisieren", jsonEncode(nachricht));
            },
            title: Text(ministrant["Vorname"] + " " + ministrant['Name']),
          );
        },
      ),
    );
  }
}
