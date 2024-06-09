import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/screens/automation_edit_screen.dart';
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
    await _backend.setup();
    await _backend.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Automation newAutomation = Automation(
              id: null,
              name: "",
              sensor: _backend.sensorMap.keys.first,
              operatorID: _backend.comparators.keys.first,
              threshold: 0,
              sensorDeviceID: 0,
              actionID: _backend.actions.keys.first,
              tradfriDeviceID: _backend.devices.first.id,
              actionPayload: null);

          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AutomationEditScreen(
                      automation: newAutomation,
                      backend: _backend))).then((value) {
            if (value == true) setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
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
                            backend: _backend,
                            reload: () {
                              setState(() {});
                            });
                      },
                      itemCount: _backend.automations.length),
                ),
              ]))),
    );
  }
}
