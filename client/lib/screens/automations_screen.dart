import 'package:flutter/cupertino.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/widgets/automation_row.dart';
import 'package:tradfri_extension/widgets/automations_row.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({Key? key}) : super(key: key);

  @override
  _AutomationsScreenState createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen> {
  final AutomationsBackend _backend = AutomationsBackend();

  @override
  void initState() {
    super.initState();
    setupBackend();
  }

  void setupBackend() async {
    print("Setting up backend...");
    await _backend.setup();
    await _backend.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(children: [
                Flex(direction: Axis.horizontal, children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const AutomationsRow([
                            "NAME",
                            "SENSOR",
                            "COMPARISON",
                            "VALUE",
                            "DEVICE",
                            "ACTION",
                            "PAYLOAD"
                          ])))
                ]),
                const SizedBox(height: 7),
                Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, i) {
                        return AutomationRow(
                            automation: _backend.automations[i],
                            backend: _backend);
                      },
                      itemCount: _backend.automations.length),
                ),
              ]))),
    );
  }
}
