import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/Tradfri_device.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/widgets/audomation_edit_row.dart';
import 'package:tradfri_extension/widgets/automation_edit_text_row.dart';

class AutomationEditScreen extends StatefulWidget {
  final Automation automation;
  final AutomationsBackend backend;

  AutomationEditScreen({required this.automation, required this.backend});

  @override
  _AutomationEditScreenState createState() => _AutomationEditScreenState();
}

class _AutomationEditScreenState extends State<AutomationEditScreen> {
  late TextEditingController nameController;
  late TextEditingController sensorController;
  late TextEditingController valueController;

  @override
  Widget build(BuildContext context) {
    setupControllers();

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.automation.name),
        ),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 900, maxHeight: 700),
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AutomationEditTextRow(
                              name: "Name",
                              controller: nameController,
                            ),
                            AutomationEditTextRow(
                              name: "Sensor",
                              controller: sensorController,
                            ),
                            // AutomationEditRow(name: "Comparison"),
                            AutomationEditTextRow(
                              name: "Value",
                              controller: valueController,
                            ),
                            AutomationEditRow(
                                name: "Device",
                                child: DropdownMenu<int>(
                                  dropdownMenuEntries: [
                                    for (TradfriDevice device
                                        in widget.backend.devices)
                                      DropdownMenuEntry(
                                          value: device.id, label: device.name)
                                  ],
                                  // AutomationEditRow(name: "Action"),
                                  // AutomationEditRow(name: "Payload"),
                                ))
                          ],
                        ))))));
  }

  void setupControllers() {
    nameController = TextEditingController(text: widget.automation.name);
    sensorController = TextEditingController(text: widget.automation.sensor);
    valueController =
        TextEditingController(text: widget.automation.threshold.toString());
  }
}
