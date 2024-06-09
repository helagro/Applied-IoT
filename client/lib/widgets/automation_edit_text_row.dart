import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradfri_extension/widgets/audomation_edit_row.dart';

class AutomationEditTextRow extends StatelessWidget {
  final String name;
  final TextEditingController controller;

  const AutomationEditTextRow({
    required this.name,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutomationEditRow(
        name: name,
        child: CupertinoTextField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9:/._-]')),
          ],
        ));
  }
}
