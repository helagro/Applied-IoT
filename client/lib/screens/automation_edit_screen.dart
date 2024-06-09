import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/Tradfri_device.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/logic/wrapper.dart';
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
  late Wrapper sensorWrapper;
  late Wrapper comparatorWrapper;
  late Wrapper actionWrapper;
  late Wrapper payloadWrapper;
  late Wrapper deviceWrapper;

  /* ------------------------ LIVECYCLE ----------------------- */

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
                                  entries: widget.backend.sensorMap,
                                  wrapper: sensorWrapper,
                                )),
                            AutomationEditRow(
                                name: "Comparison",
                                child: AutomationDropdown(
                                    wrapper: comparatorWrapper,
                                    entries: widget.backend.comparators)),
                            AutomationEditTextRow(
                              name: "Value",
                              controller: valueController,
                            ),
                            AutomationEditRow(
                                name: "Device",
                                child: AutomationDropdown(
                                    wrapper: deviceWrapper,
                                    entries: widget.backend.getDeviceMap())),
                            AutomationEditRow(
                                name: "Action",
                                child: AutomationDropdown(
                                    wrapper: actionWrapper,
                                    entries: widget.backend.actions)),
                            AutomationEditRow(
                                name: "Payload",
                                child: AutomationDropdown(
                                    wrapper: payloadWrapper,
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
                                            sensorWrapper.value,
                                            valueController.text,
                                            comparatorWrapper.value,
                                            deviceWrapper.value,
                                            actionWrapper.value,
                                            payloadWrapper.value);
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

  /* ------------------------- METHODS ------------------------ */

  void setupControllers() {
    nameController = TextEditingController(text: widget.automation.name);
    valueController =
        TextEditingController(text: widget.automation.threshold.toString());

    sensorWrapper = Wrapper(widget.backend.sensorMap[widget.automation.sensor]);
    comparatorWrapper =
        Wrapper(widget.backend.comparators[widget.automation.operatorID]);
    actionWrapper = Wrapper(widget.backend.actions[widget.automation.actionID]);
    payloadWrapper = Wrapper(widget.automation.actionPayload);
    deviceWrapper = Wrapper(widget.automation.tradfriDeviceID);
  }
}
