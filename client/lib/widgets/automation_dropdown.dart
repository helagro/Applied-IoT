import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/wrapper.dart';

class AutomationDropdown extends StatefulWidget {
  final Map<String, dynamic> entries;
  final Wrapper? wrapper;

  AutomationDropdown({
    required this.entries,
    this.wrapper,
    super.key,
  });

  @override
  _AutomationDropdownState createState() => _AutomationDropdownState();
}

class _AutomationDropdownState extends State<AutomationDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      onChanged: (value) {
        setState(() {
          widget.wrapper?.value = value;
        });
      },
      value: widget.wrapper?.value,
      items: widget.entries.entries
          .map((entry) => DropdownMenuItem<dynamic>(
                value: entry.value,
                child: Text(entry.key),
              ))
          .toList(),
    );
  }
}
