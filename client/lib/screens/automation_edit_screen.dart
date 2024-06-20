import 'package:flutter/cupertino.dart';
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
  bool? allDevicesSelected;

  // Text controllers
  late TextEditingController nameController;
  late TextEditingController valueController;
  late TextEditingController sensorDeviceController;
  late TextEditingController payloadController;

  // Data wrappers for accessing input values
  late Wrapper sensorWrapper;
  late Wrapper comparatorWrapper;
  late Wrapper actionWrapper;
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
                heightFactor: 1,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: SingleChildScrollView(
                        child: Container(
                            height: 600,
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
                                        entries:
                                            widget.backend.getDeviceMap())),
                                AutomationEditRow(
                                    name: "Action",
                                    child: AutomationDropdown(
                                        wrapper: actionWrapper,
                                        entries: widget.backend.actions)),
                                AutomationEditTextRow(
                                    name: "Payload",
                                    controller: payloadController),
                                AutomationEditRow(
                                    name: "Sensor Device",
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: CupertinoTextField(
                                                enabled: !doSelectAllDevices(),
                                                controller:
                                                    sensorDeviceController),
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: const Text(
                                                  "Select all devices: ")),
                                          Checkbox(
                                              value: doSelectAllDevices(),
                                              onChanged: onAllDevicesSelect)
                                        ])),
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
                            )))))));
  }

  /* ------------------------- METHODS ------------------------ */

  void setupControllers() {
    String sensorDeviceText = doSelectAllDevices()
        ? "-1"
        : widget.automation.sensorDeviceID == -1
            ? '0'
            : widget.automation.sensorDeviceID.toString();

    // Setup controllers
    nameController = TextEditingController(text: widget.automation.name);
    valueController =
        TextEditingController(text: widget.automation.threshold.toString());
    sensorDeviceController = TextEditingController(text: sensorDeviceText);
    payloadController =
        TextEditingController(text: widget.automation.actionPayload.toString());

    // Setup wrappers
    sensorWrapper = Wrapper(widget.automation.sensor);
    comparatorWrapper = Wrapper(widget.automation.operatorID);
    actionWrapper = Wrapper(widget.automation.actionID);
    deviceWrapper = Wrapper(widget.automation.tradfriDeviceID);
  }

  /* --------------------- EVENT LISTENERS -------------------- */

  Future<void> onSave(BuildContext context) async {
    int sensorDeviceID;
    double threshold;
    int payload;

    try {
      sensorDeviceID = int.parse(sensorDeviceController.text);
      threshold = double.parse(valueController.text);
      payload = int.parse(payloadController.text);
    } catch (e) {
      errorToast("E-14: $e");
      return;
    }

    Automation updatedAutomation = Automation(
        id: widget.automation.id,
        name: nameController.text,
        sensor: sensorWrapper.value,
        threshold: threshold,
        operatorID: comparatorWrapper.value,
        tradfriDeviceID: deviceWrapper.value,
        actionID: actionWrapper.value,
        actionPayload: payload,
        sensorDeviceID: sensorDeviceID);

    await widget.backend.updateAutomation(updatedAutomation);
    await widget.backend.loadAutomations();

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> onDelete(BuildContext context) async {
    await widget.backend.deleteAutomation(widget.automation.id);
    await widget.backend.loadAutomations();

    if (context.mounted) {
      Navigator.pop(context, true);
    }
  }

  bool doSelectAllDevices() {
    if (allDevicesSelected != null) return allDevicesSelected!;

    return widget.automation.sensorDeviceID == -1;
  }

  void onAllDevicesSelect(bool? selected) {
    String inputSensorDeviceID = sensorDeviceController.text;
    if (selected == true && int.tryParse(inputSensorDeviceID) != null) {
      widget.automation.sensorDeviceID = int.parse(inputSensorDeviceID);
    }

    setState(() {
      allDevicesSelected = selected;
    });
  }
}
