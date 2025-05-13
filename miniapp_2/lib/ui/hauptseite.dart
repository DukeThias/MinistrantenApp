import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import '../logik/globals.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Hauptseite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    final globals = context.watch<Globals>();
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ws.verbunden ? "Verbunden" : "Nicht verbunden"),

            ElevatedButton(
              onPressed:
                  ws.verbunden
                      ? () {
                        ws.senden("ping", Random().nextInt(100).toString());
                      }
                      : null,
              child: Text("Senden"),
            ),
            Row(children: [SpinKitCircle(color: Get.iconColor, size: 50)]),

            Expanded(
              child: ListView.builder(
                itemCount: ws.nachrichten.length,
                itemBuilder:
                    (_, i) => ListTile(title: Text(ws.nachrichten[i].inhalt)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
