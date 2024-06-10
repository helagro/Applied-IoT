import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomationEditRow extends StatelessWidget {
  final String name;
  final Widget child;

  const AutomationEditRow({
    required this.name,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(children: [
      Text(name),
      const SizedBox(width: 20),
      Expanded(child: child)
    ]));
  }
}
