import 'package:flutter/material.dart';

List<NavigationDestination> destinations(List? rollen) {
  final List<NavigationDestination> destinations = [
    NavigationDestination(icon: Icon(Icons.home), label: "Home"),
    NavigationDestination(icon: Icon(Icons.calendar_month), label: "Miniplan"),
    NavigationDestination(
      icon: Icon(Icons.swap_horizontal_circle_rounded),
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
