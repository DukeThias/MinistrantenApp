import 'package:flutter/material.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/Termine_verwalten_omis.dart';
import 'package:miniapp_2/ui/hauptseite/einzelne%20seiten/uploadhtml.dart';
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
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Termine verwalten"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermineVerwaltenOmis()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.upload_file),
            title: Text("Miniplan hochladen (.html)"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadHtmlPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
