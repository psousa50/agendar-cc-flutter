import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/data/models.dart';

class TablesByDateView extends StatefulWidget {
  final IrnTables tables;
  final DateTime? selectedDate;
  final DateTime? focusedDay;
  final Function(DateTime, DateTime) onDateSelected;

  const TablesByDateView({
    required this.tables,
    this.selectedDate,
    this.focusedDay,
    required this.onDateSelected,
  });

  @override
  _TablesByDateViewState createState() => _TablesByDateViewState();
}

class _TablesByDateViewState extends State<TablesByDateView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  void onFormatChanged(CalendarFormat calendarFormat) {
    setState(() {
      _calendarFormat = calendarFormat;
    });
  }

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
    var firstDay = minDate ?? DateTime.now();
    var lastDay = maxDate ?? DateTime.now();
    var focusedDay = widget.focusedDay ?? minDate ?? DateTime.now();
    focusedDay = focusedDay.isBefore(firstDay) ? firstDay : focusedDay;
    focusedDay = focusedDay.isAfter(lastDay) ? lastDay : focusedDay;

    return TableCalendar(
      selectedDayPredicate: (date) => dateOnly(date) == widget.selectedDate,
      shouldFillViewport: true,
      onDaySelected: (selectedDay, focusedDay) => widget.onDateSelected(
        dateOnly(selectedDay),
        dateOnly(focusedDay),
      ),
      firstDay: firstDay,
      lastDay: lastDay,
      focusedDay: focusedDay,
      eventLoader: (DateTime date) {
        return groupedTablesByPlace[dateOnly(date)] ?? [];
      },
      calendarFormat: _calendarFormat,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      onFormatChanged: onFormatChanged,
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(50.0)),
          child: Text(
            date.day.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
