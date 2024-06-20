import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/screens/automation_edit_screen.dart';
import 'package:tradfri_extension/widgets/automation_row.dart';
import 'package:tradfri_extension/widgets/automations_row.dart';

class AutomationsScreen extends StatefulWidget {
  const AutomationsScreen({super.key});

  @override
  State<AutomationsScreen> createState() => _AutomationsScreenState();
}

class _AutomationsScreenState extends State<AutomationsScreen> {
  final AutomationsBackend _backend = AutomationsBackend();

  /* -------------------------- SETUP ------------------------- */

  @override
  void initState() {
    super.initState();
    setupBackend();
  }

  Future<void> setupBackend() async {
    await _backend.setup();
    await _backend.getData();

    if (context.mounted) {
      setState(() {});
    }
  }

  /* ------------------------ LIFECYCLE ----------------------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => onCreateAutomation(context),
        child: const Icon(Icons.add),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 970),
                  child: Column(children: [
                    Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(5),
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
                                reload: onReload);
                          },
                          itemCount: _backend.automations.length),
                    ),
                  ])))),
    );
  }

  /* ---------------------- OTHER METHODS --------------------- */

  Future<void> onCreateAutomation(BuildContext context) async {
    Automation newAutomation = Automation(
        id: null,
        name: "",
        sensor: _backend.sensorMap.values.first,
        operatorID: _backend.comparators.values.first,
        threshold: 0,
        sensorDeviceID: 0,
        actionID: _backend.actions.values.first,
        tradfriDeviceID: _backend.devices.first.id,
        actionPayload: null);

    dynamic value = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AutomationEditScreen(
                automation: newAutomation, backend: _backend)));

    if (value == true && context.mounted) setState(() {});
  }

  Future<void> onReload() async {
    if (mounted) setState(() {});
  }
}
