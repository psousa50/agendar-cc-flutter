import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/data/models.dart';

class TablesByDateView extends StatefulWidget {
  final IrnTables tables;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const TablesByDateView({
    required this.tables,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  _TablesByDateViewState createState() => _TablesByDateViewState();
}

class _TablesByDateViewState extends State<TablesByDateView> {
  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<IrnTable>> groupedTables =
        groupBy(widget.tables, (t) => t.date);
    var groupedTablesByPlace = groupedTables.map(
      (key, tables) => MapEntry(
        key,
        tables.map((t) => t.placeName).toSet().toList(),
      ),
    );
    var minDate = (groupedTablesByPlace.keys.length > 0
        ? groupedTablesByPlace.keys.reduce(
            (value, element) => element.isBefore(value) ? element : value)
        : null);
    var maxDate = (groupedTablesByPlace.keys.length > 0
        ? groupedTablesByPlace.keys.reduce(
            (value, element) => element.isAfter(value) ? element : value)
        : null);
    return Container(
      child: TableCalendar(
        selectedDayPredicate: (date) => dateOnly(date) == widget.selectedDate,
        shouldFillViewport: true,
        onDaySelected: (selectedDay, focusedDay) =>
            widget.onDateSelected(dateOnly(selectedDay)),
        firstDay: minDate ?? DateTime.now(),
        lastDay: maxDate ?? DateTime.now(),
        focusedDay: widget.selectedDate ?? minDate ?? DateTime.now(),
        eventLoader: (DateTime date) {
          return groupedTablesByPlace[dateOnly(date)] ?? [];
        },
        calendarFormat: CalendarFormat.month,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(50.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
