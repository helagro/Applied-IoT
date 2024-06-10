import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class SettingsRow extends StatelessWidget {
  final String text;
  final TextEditingController? controller;

  const SettingsRow({
    required this.text,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(children: [
      Text(text),
      const SizedBox(width: 20),
      Expanded(
          child: CupertinoTextField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9:/._-]')),
        ],
      ))
    ]));
  }
}
