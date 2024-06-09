import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';

class AutomationRow extends StatelessWidget {
  final Automation automation;
  final AutomationsBackend backend;

  const AutomationRow({required this.automation, required this.backend});

  @override
  Widget build(BuildContext context) {
    print("Sensors ${jsonEncode(backend.sensorMap)}");

    return Flex(direction: Axis.horizontal, children: [
      Expanded(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Row(children: [
                Text(automation.name),
                SizedBox(width: 10),
                Text(
                    "${automation.sensor} ${backend.sensorMap[automation.sensor]}"),
              ])))
    ]);
  }
}
