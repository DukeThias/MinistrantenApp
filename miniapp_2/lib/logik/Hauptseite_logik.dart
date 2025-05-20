import 'package:flutter/material.dart';
import 'package:miniapp_2/services/WebSocketVerbindung.dart';

List<NavigationDestination> destinations(List? rollen, Websocketverbindung ws) {
  final List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.calendar_month), label: "Miniplan"),
    NavigationDestination(
      icon: Icon(
        Icons.swap_horizontal_circle_rounded,
        color: !ws.verbunden ? const Color.fromARGB(255, 107, 107, 107) : null,
      ),
      label: "Tauschen",
    ),
  ];

  if (rollen != null && rollen!.contains("omi")) {
    destinations.add(
      NavigationDestination(icon: Icon(Icons.settings), label: "Omi"),
    );
  }

  return destinations;
}
