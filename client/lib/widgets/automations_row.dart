import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomationsRow extends StatelessWidget {
  static const double columnGap = 6;
  final List<String> items;

  const AutomationsRow(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 820) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Text(items[0]),
            ),
            const SizedBox(width: columnGap),
            Expanded(
              flex: 3,
              child: Text(items[1]),
            ),
            const SizedBox(width: columnGap),
            Expanded(
              flex: 3,
              child: Text(items[2]),
            ),
            const SizedBox(width: columnGap),
            Expanded(
              flex: 1,
              child: Text(items[3]),
            ),
            const SizedBox(width: columnGap),
            Expanded(
              flex: 3,
              child: Text(items[4]),
            ),
            const SizedBox(width: columnGap),
            Expanded(
              flex: 2,
              child: Text(items[5]),
            ),
            const SizedBox(width: columnGap),
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
