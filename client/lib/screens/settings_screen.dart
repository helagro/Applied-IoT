import 'package:flutter/material.dart';
import 'package:tradfri_extension/widgets/settings_row.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              padding: EdgeInsets.all(15),
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: [
                      Row(children: [
                        SettingsRow(title: "Test", subtitle: "Subtitle")
                      ])
                    ],
                  )))),
    );
  }
}
