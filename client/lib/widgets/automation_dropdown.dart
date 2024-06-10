import 'package:flutter/material.dart';
import 'package:tradfri_extension/logic/wrapper.dart';

class AutomationDropdown extends StatefulWidget {
  final Map<String, dynamic> entries;
  final Wrapper? wrapper;

  const AutomationDropdown({
    required this.entries,
    this.wrapper,
    super.key,
  });

  @override
  State<AutomationDropdown> createState() => _AutomationDropdownState();
}

class _AutomationDropdownState extends State<AutomationDropdown> {
  /* ------------------------ LIFECYCLE ----------------------- */

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      onChanged: onChanged,
      value: widget.wrapper?.value,
      items: getDropdownItems(),
    );
  }

  /* ---------------------- OTHER METHODS --------------------- */

  void onChanged(dynamic value) {
    setState(() {
      widget.wrapper?.value = value;
    });
  }

  List<DropdownMenuItem<dynamic>> getDropdownItems() {
    return widget.entries.entries
        .map((entry) => DropdownMenuItem<dynamic>(
              value: entry.value,
              child: Text(entry.key),
            ))
        .toList();
  }
}
