import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradfri_extension/logic/Automation.dart';
import 'package:tradfri_extension/logic/automations_backend.dart';

class AutomationsRow extends StatelessWidget {
  final List<String> items;

  const AutomationsRow(this.items);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 4,
              child: Text(items[0]),
            ),
            Expanded(
              flex: 3,
              child: Text(items[1]),
            ),
            Expanded(
              flex: 4,
              child: Text(items[2]),
            ),
            Expanded(
              flex: 2,
              child: Text(items[3]),
            ),
            Expanded(
              flex: 2,
              child: Text(items[4]),
            ),
            Expanded(
              flex: 2,
              child: Text(items[5]),
            ),
            Expanded(
              flex: 2,
              child: Text(
                items[6],
              ),
            ),
          ],
        );
      } else {
        return Center(
            child: Text(
          items[0],
          style: const TextStyle(fontSize: 14.5),
        ));
      }
    });
  }
}
