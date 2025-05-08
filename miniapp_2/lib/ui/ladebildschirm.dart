import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/WebSocketVerbindung.dart';
import '../logik/WebSocketLogik.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Ladebildschirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ws = Provider.of<Websocketverbindung>(context);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(ws.verbunden ? "Verbunden" : "Nicht verbunden"),
            ElevatedButton(
              onPressed: () => ws.verbinde("ws://localhost:5205/ws"),
              child: Text("Verbinden"),
            ),
            ElevatedButton(
              onPressed: () => ws.senden("Hallo vom Flutter Client!"),
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
