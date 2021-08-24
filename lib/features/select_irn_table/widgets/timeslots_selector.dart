import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../core/data/models.dart';

class TimeSlotsSelector extends StatelessWidget {
  static var hourFormat = NumberFormat("00");
  final Function(TimeOfDay) onTimeSlotSelected;

  final IrnTables tables;
  const TimeSlotsSelector({
    Key? key,
    required this.tables,
    required this.onTimeSlotSelected,
  }) : super(key: key);

  List<String> pad(List<String> slots, int count) {
    return [
      ...slots,
      ...Iterable.generate(count - slots.length).map((_) => "")
    ];
  }

  Widget buildSlot(BuildContext context, String slot) {
    return Expanded(
      flex: 10,
      child: slot == ""
          ? Container()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: TextButton(
                onPressed: () => onTimeSlotSelected(timeOfDayFromSlot(slot)),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildTimeRow(BuildContext context, int hour, List<String> slots) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        CircleAvatar(
          radius: 15,
          child: Text(
            "${hourFormat.format(hour)}",
            style: TextStyle(fontSize: 12),
          ),
        ),
        ...pad(slots, 4).map((s) => buildSlot(context, s)).toList(),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var uniqueTimeSlots = tables
        .map((t) => t.timeSlots.map((ts) => ts.substring(0, 5)))
        .expand((t) => t)
        .toSet()
        .toList()
          ..sort();
    Map<int, List<String>> timeSlots =
        groupBy(uniqueTimeSlots, (t) => int.parse(t.substring(0, 2)));
    var keys = timeSlots.keys.toList();
    return ListView.separated(
      itemBuilder: (c, i) => buildTimeRow(c, keys[i], timeSlots[keys[i]]!),
      separatorBuilder: (_, __) => Divider(
        height: 1,
        thickness: 2,
      ),
      itemCount: keys.length,
    );
  }
}
