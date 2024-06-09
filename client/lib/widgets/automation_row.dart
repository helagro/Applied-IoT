import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';
import 'package:tradfri_extension/screens/automation_edit_screen.dart';
import 'package:tradfri_extension/widgets/automations_row.dart';

class AutomationRow extends StatelessWidget {
  final Automation automation;
  final AutomationsBackend backend;

  const AutomationRow({required this.automation, required this.backend});

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                  onTap: () {
                    print("Pressed ${automation.name}");
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => AutomationEditScreen(
                                automation: automation, backend: backend)));
                  },
                  child: AutomationsRow([
                    automation.name,
                    automation.sensor,
                    automation.operatorID.toString(),
                    automation.threshold.toString(),
                    automation.tradfriDeviceID.toString(),
                    automation.actionID,
                    jsonEncode(automation.actionPayload),
                  ]))))
    ]);
  }
}
