import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DurationPicker extends StatefulWidget {
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
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  int selectedHours = 0;
  int selectedMinutes = 0;

  @override
  void initState() {
    super.initState();
    selectedHours = widget.initialHours;
    selectedMinutes = widget.initialMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Hours picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: selectedHours),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (value) => setState(() {
                      selectedHours = value;
                    }),
                    children: List<Widget>.generate(24, (index) => Text("$index h")),
                  ),
                ),
                // Minutes picker
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: selectedMinutes),
                    itemExtent: 32.0,
                    onSelectedItemChanged: (value) => setState(() {
                      selectedMinutes = value;
                    }),
                    children: List<Widget>.generate(60, (index) => Text("$index m")),
                  ),
                ),
              ],
            ),
          ),
          // "Done" button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final duration = Duration(hours: selectedHours, minutes: selectedMinutes);
                widget.onDurationChanged(duration);
                Navigator.pop(context); // Close the modal
              },
              child: Text('Done'),
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
