import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import '../logik/WebSocketLogik.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Hauptseite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ws = context.watch<Websocketverbindung>();
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(ws.verbunden ? "Verbunden" : "Nicht verbunden"),

            ElevatedButton(
              onPressed: () => ws.senden("Hallo vom Flutter Client2!"),
              child: Text("Senden"),
            ),
            Row(children: [SpinKitCircle(color: Get.iconColor, size: 50)]),

            Expanded(
              child: ListView.builder(
                itemCount: ws.nachrichten.length,
                itemBuilder:
                    (_, i) => ListTile(
                      title: Text(verarbeiteNachricht(ws.nachrichten[i])),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
