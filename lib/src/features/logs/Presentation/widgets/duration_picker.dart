import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DurationPicker extends StatelessWidget {
  final int initialHours;
  final int initialMinutes;
  final ValueChanged<Duration> onDurationChanged;

  const DurationPicker({
    Key? key,
    this.initialHours = 0,
    this.initialMinutes = 0,
    required this.onDurationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedHours = initialHours;
    int selectedMinutes = initialMinutes;

    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: initialHours),
              itemExtent: 32.0,
              onSelectedItemChanged: (value) => selectedHours = value,
              children: List<Widget>.generate(24, (index) => Text("$index h")),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: initialMinutes),
              itemExtent: 32.0,
              onSelectedItemChanged: (value) => selectedMinutes = value,
              children: List<Widget>.generate(60, (index) => Text("$index m")),
            ),
          ),
        ],
      ),
    );
  }
}

void showDurationPicker(
  BuildContext context,
  int initialHours,
  int initialMinutes,
  ValueChanged<Duration> onDurationPicked,
) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return DurationPicker(
        initialHours: initialHours,
        initialMinutes: initialMinutes,
        onDurationChanged: onDurationPicked,
      );
    },
  );
}
