import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AutomationRow extends StatelessWidget {
  final String name;
  final String subtitle;
  final Function()? onTap;

  const AutomationRow({
    required this.name,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(children: [
      Text("Server URL"),
      SizedBox(width: 20),
      Expanded(
          child: CupertinoTextField(
        placeholder: "Enter server URL",
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9:/._-]')),
        ],
      ))
    ]));
  }
}
