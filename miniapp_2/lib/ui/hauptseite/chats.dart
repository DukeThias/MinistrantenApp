import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/hauptseite_drawer.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),

      appBar: AppBar(title: Text("Chats")),
      body: Center(child: Text("Hier sind deine Chats")),
    );
  }
}
