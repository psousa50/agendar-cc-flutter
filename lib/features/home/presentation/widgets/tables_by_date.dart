import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/data/models.dart';
import '../../../../themes.dart';

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

    List<String> events(DateTime date) {
      return groupedTablesByPlace[dateOnly(date)] ?? [];
    }

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
      eventLoader: (DateTime date) => events(date),
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
        defaultBuilder: (context, date, focusedDay) {
          var hasEvents = events(date).length > 0;
          return DayCircle(
            day: date.day,
            circleColor: hasEvents
                ? AppColors.foundTable
                : Theme.of(context).scaffoldBackgroundColor,
            textStyle: hasEvents
                ? Theme.of(context).accentTextTheme.bodyText1
                : Theme.of(context).textTheme.bodyText1,
          );
        },
        selectedBuilder: (context, date, focusedDay) => DayCircle(
          day: date.day,
          circleColor: AppColors.selectedTable,
          textStyle: Theme.of(context).accentTextTheme.bodyText1,
        ),
      ),
    );
  }
}

class DayCircle extends StatelessWidget {
  final int day;
  final Color circleColor;
  final TextStyle? textStyle;

  const DayCircle({
    required this.day,
    required this.circleColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    var margin = MediaQuery.of(context).size.width / 100.0;
    print(margin);
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.all(margin),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        day.toString(),
        style: textStyle,
      ),
    );
  }
}
