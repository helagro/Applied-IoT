import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/screens/automation_edit_screen.dart';
import 'package:tradfri_extension/widgets/automations_row.dart';

class AutomationRow extends StatelessWidget {
  final Automation automation;
  final AutomationsBackend backend;
  final Function? reload;

  const AutomationRow(
      {required this.automation,
      required this.backend,
      this.reload,
      super.key});

  /* ------------------------ LIFECYCLE ----------------------- */

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                  onTap: () => goToEditScreen(context),
                  child: AutomationsRow([
                    automation.name,
                    backend.sensorMapReverse[automation.sensor]!,
                    backend.comparatorsReverse[automation.operatorID]!,
                    automation.threshold.toString(),
                    backend.getDeviceById(automation.tradfriDeviceID).name,
                    backend.actionsReverse[automation.actionID]!,
                    jsonEncode(automation.actionPayload),
                  ]))))
    ]);
  }

  /* ---------------------- OTHER METHODS --------------------- */

  void goToEditScreen(BuildContext context) async {
    dynamic value = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AutomationEditScreen(
                automation: automation, backend: backend)));

    if (value == true && reload != null) reload!();
  }
}
