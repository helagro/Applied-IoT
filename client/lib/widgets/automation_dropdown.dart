import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomationDropdown extends StatelessWidget {
  final dynamic initialSelection;
  final Map<String, dynamic> entries;

  const AutomationDropdown({
    required this.initialSelection,
    required this.entries,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<dynamic>(
      initialSelection: initialSelection,
      dropdownMenuEntries: [
        for (String key in entries.keys)
          DropdownMenuEntry(value: entries[key], label: key)
      ],
    );
  }
}
