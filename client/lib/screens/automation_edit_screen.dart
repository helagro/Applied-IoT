import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/Tradfri_device.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/widgets/automation_dropdown.dart';
import 'package:tradfri_extension/widgets/automation_edit_row.dart';
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
                            AutomationEditRow(
                                name: "Sensor",
                                child: AutomationDropdown(
                                    initialSelection: widget.backend
                                        .sensorMap[widget.automation.sensor],
                                    entries: widget.backend.sensorMap)),
                            AutomationEditRow(
                                name: "Comparison",
                                child: AutomationDropdown(
                                    initialSelection:
                                        widget.backend.comparators[
                                            widget.automation.operatorID],
                                    entries: widget.backend.comparators)),
                            AutomationEditTextRow(
                              name: "Value",
                              controller: valueController,
                            ),
                            AutomationEditRow(
                                name: "Device",
                                child: DropdownMenu<dynamic>(
                                  initialSelection:
                                      widget.automation.tradfriDeviceID,
                                  dropdownMenuEntries: [
                                    for (TradfriDevice device
                                        in widget.backend.devices)
                                      DropdownMenuEntry(
                                          value: device.id, label: device.name)
                                  ],
                                )),
                            AutomationEditRow(
                                name: "Action",
                                child: AutomationDropdown(
                                    initialSelection: widget.backend
                                        .actions[widget.automation.actionID],
                                    entries: widget.backend.actions)),
                            AutomationEditRow(
                                name: "Payload",
                                child: AutomationDropdown(
                                    initialSelection:
                                        widget.automation.actionPayload,
                                    entries: const {
                                      "True": true,
                                      "False": false,
                                      "None": null
                                    })),
                            Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Row(children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        widget.backend.updateAutomation(
                                            widget.automation.id,
                                            nameController.text,
                                            widget.backend.sensorMap.keys.firstWhere((key) =>
                                                widget.backend.sensorMap[key] ==
                                                widget.backend.sensorMap[
                                                    widget.automation.sensor]),
                                            valueController.text,
                                            widget.backend.comparators.keys.firstWhere((key) =>
                                                widget.backend.comparators[key] ==
                                                widget.backend.comparators[widget
                                                    .automation.operatorID]),
                                            widget.backend.devices
                                                .firstWhere((device) => device.id == widget.automation.tradfriDeviceID),
                                            widget.backend.actions.keys.firstWhere((key) => widget.backend.actions[key] == widget.backend.actions[widget.automation.actionID]),
                                            widget.automation.actionPayload);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Save")),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("Delete");
                                      },
                                      child: const Text("Delete")),
                                ]),
                              ),
                            )
                          ],
                        ))))));
  }

  void setupControllers() {
    nameController = TextEditingController(text: widget.automation.name);
    valueController =
        TextEditingController(text: widget.automation.threshold.toString());
  }
}
