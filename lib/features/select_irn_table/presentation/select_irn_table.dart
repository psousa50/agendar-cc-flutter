import 'package:agendar_cc_flutter/features/schedule_at_irn/presentation/schedule_at_irn.dart';
import 'package:agendar_cc_flutter/widgets/page_with_app_bar.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:agendar_cc_flutter/core/data/models.dart';
import 'package:agendar_cc_flutter/core/service_locator.dart';
import 'package:intl/intl.dart';

class IrnTableSelectionData {
  final String service;
  final String county;
  final String place;
  final String date;
  const IrnTableSelectionData({
    this.service = "...",
    this.county = "...",
    this.place = "...",
    this.date = "...",
  });
}

class SelectIrnTable extends StatelessWidget {
  final IrnTables tables;
  final IrnTableSelection tableSelection;
  const SelectIrnTable({
    Key? key,
    required this.tables,
    required this.tableSelection,
  }) : super(key: key);

  IrnTableSelectionData from(IrnTableSelection t) {
    var r = ServiceLocator.referenceData;
    return IrnTableSelectionData(
      service: r.irnService(t.serviceId).name,
      county: r.county(t.countyId).name,
      place: t.placeName,
      date: t.date.toIso8601String().substring(0, 10),
    );
  }

  void onTimeSlotSelected(BuildContext context, TimeOfDay time) {
    var timeSlot = time.toSlot8();
    var tableNumber =
        tables.where((t) => t.timeSlots.contains(timeSlot)).first.tableNumber;
    var fullTableSelection = tableSelection.copyWith(
      timeSlot: timeSlot,
      tableNumber: tableNumber,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScheduleAtIrnPage(fullTableSelection)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cardData = from(tableSelection);
    return MainPage(
      child: PageWithAppBar(
        title: "Seleccionar",
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                TableCardView(cardData),
                Expanded(
                  child: TimeTable(
                    tables: tables.filterBy(tableSelection),
                    onTimeSlotSelected: (slot) =>
                        onTimeSlotSelected(context, slot),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeTable extends StatelessWidget {
  static var hourFormat = NumberFormat("00");
  final Function(TimeOfDay) onTimeSlotSelected;

  final IrnTables tables;
  const TimeTable({
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

  Widget buildSlot(String slot) {
    return Expanded(
      flex: 10,
      child: TextButton(
        onPressed: () => onTimeSlotSelected(timeOfDayFromSlot(slot)),
        child: Text(
          slot,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget buildTimeRow(int hour, List<String> slots) {
    return Row(children: [
      Text(
        "${hourFormat.format(hour)}",
      ),
      Spacer(flex: 1),
      ...pad(slots, 5).map(buildSlot).toList(),
    ]);
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
    return ListView(
      shrinkWrap: true,
      children: timeSlots.keys
          .map(
            (k) => buildTimeRow(k, timeSlots[k]!),
          )
          .toList(),
    );
  }
}

class TableCardView extends StatelessWidget {
  final IrnTableSelectionData tableCard;
  const TableCardView(this.tableCard);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.service,
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).primaryColor),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tableCard.county,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.place,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.date,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
