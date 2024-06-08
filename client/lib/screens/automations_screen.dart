import 'package:flutter/cupertino.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/widgets/automation_row.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({Key? key}) : super(key: key);

  @override
  _AutomationsScreenState createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen> {
  AutomationsBackend _backend = AutomationsBackend();

  @override
  void initState() {
    setupBackend();
  }

  void setupBackend() async {
    print("Setting up backend...");
    await _backend.setup();
    await _backend.getData();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
          child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 900),
              child: Column(
                children: [AutomationRow(name: "Title", subtitle: "Subtitle")],
              ))),
    );
  }
}
