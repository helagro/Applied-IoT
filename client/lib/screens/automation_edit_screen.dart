import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/logic/wrapper.dart';
import 'package:tradfri_extension/toasts.dart';
import 'package:tradfri_extension/widgets/automation_dropdown.dart';
import 'package:tradfri_extension/widgets/automation_edit_row.dart';
import 'package:tradfri_extension/widgets/automation_edit_text_row.dart';

class AutomationEditScreen extends StatefulWidget {
  final Automation automation;
  final AutomationsBackend backend;

  const AutomationEditScreen(
      {required this.automation, required this.backend, super.key});

  @override
  State<AutomationEditScreen> createState() => _AutomationEditScreenState();
}

class _AutomationEditScreenState extends State<AutomationEditScreen> {
  // Text controllers
  late TextEditingController nameController;
  late TextEditingController valueController;
  late TextEditingController sensorDeviceController;

  // Data wrappers for accessing input values
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
                            AutomationEditTextRow(
                                name: "Sensor Device",
                                controller: sensorDeviceController),
                            Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Row(children: [
                                  ElevatedButton(
                                      onPressed: () => onSave(context),
                                      child: const Text("Save")),
                                  const SizedBox(width: 20),
                                  ElevatedButton(
                                      onPressed: () => onDelete(context),
                                      child: const Text("Delete")),
                                ]),
                              ),
                            )
                          ],
                        ))))));
  }

  /* ------------------------- METHODS ------------------------ */

  void setupControllers() {
    // Setup controllers
    nameController = TextEditingController(text: widget.automation.name);
    valueController =
        TextEditingController(text: widget.automation.threshold.toString());
    sensorDeviceController = TextEditingController(
        text: widget.automation.sensorDeviceID.toString());

    // Setup wrappers
    sensorWrapper = Wrapper(widget.automation.sensor);
    comparatorWrapper = Wrapper(widget.automation.operatorID);
    actionWrapper = Wrapper(widget.automation.actionID);
    payloadWrapper = Wrapper(widget.automation.actionPayload);
    deviceWrapper = Wrapper(widget.automation.tradfriDeviceID);
  }

  /* --------------------- EVENT LISTENERS -------------------- */

  void onSave(BuildContext context) async {
    int sensorDeviceID;

    try {
      sensorDeviceID = int.parse(sensorDeviceController.text);
    } catch (e) {
      errorToast("E-14: $e");
      return;
    }

    await widget.backend.updateAutomation(
        widget.automation.id,
        nameController.text,
        sensorWrapper.value,
        valueController.text,
        comparatorWrapper.value,
        deviceWrapper.value,
        actionWrapper.value,
        payloadWrapper.value,
        sensorDeviceID);

    await widget.backend.loadAutomations();

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  void onDelete(BuildContext context) async {
    await widget.backend.deleteAutomation(widget.automation.id);
    await widget.backend.loadAutomations();

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }
}
