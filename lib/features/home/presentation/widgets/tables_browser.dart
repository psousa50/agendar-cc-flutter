import 'package:agendar_cc_flutter/core/service_locator.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import 'current_selection.dart';
import 'filter_info.dart';
import 'tables_by_date.dart';
import 'tables_by_location.dart';

class TablesBrowser extends StatefulWidget {
  final IrnTables tables;
  const TablesBrowser(this.tables);

  @override
  _TablesBrowserState createState() => _TablesBrowserState();
}

class _TablesBrowserState extends State<TablesBrowser> {
  DateTime? _selectedDate;
  DateTime? _focusedDay;
  String? _selectedPlace;

  @override
  void didUpdateWidget(covariant TablesBrowser oldWidget) {
    _selectedDate = null;
    _focusedDay = null;
    _selectedPlace = null;
    super.didUpdateWidget(oldWidget);
  }

  void onDateSelected(DateTime date, DateTime focusedDay) {
    if (_selectedDate != date &&
        widget.tables.where((t) => t.date == date).isEmpty) {
      return;
    }

    var newSelectedDate = _selectedDate == date ? null : date;

    setState(() {
      _selectedDate = newSelectedDate;
      _focusedDay = focusedDay;
    });
  }

  void onPlaceSelected(String place) {
    var newSelectedPlace = _selectedPlace == place ? null : place;

    setState(() {
      _selectedPlace = newSelectedPlace;
      _focusedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.normalize().maxWidth < 480) {
        return Column(
          children: [
            FilterInfo(ServiceLocator.tablesFilter),
            CurrentSelection(widget.tables, _selectedDate, _selectedPlace),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: MediaQuery.of(context).size.height * .3),
                child: TablesByDateView(
                  tables: widget.tables.where(
                    (t) =>
                        _selectedPlace == null || t.placeName == _selectedPlace,
                  ),
                  selectedDate: _selectedDate,
                  focusedDay: _focusedDay,
                  onDateSelected: onDateSelected,
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TablesByLocation(
                tables: widget.tables.where(
                    (t) => _selectedDate == null || t.date == _selectedDate),
                selectedPlace: _selectedPlace,
                onPlaceSelected: onPlaceSelected,
              ),
            )),
          ],
        );
      } else {
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: FilterInfo(ServiceLocator.tablesFilter)),
                Expanded(
                    child: CurrentSelection(
                        widget.tables, _selectedDate, _selectedPlace)),
              ],
            ),
            Expanded(
              child: Row(children: [
                Expanded(
                  child: TablesByDateView(
                    tables: widget.tables.where(
                      (t) =>
                          _selectedPlace == null ||
                          t.placeName == _selectedPlace,
                    ),
                    selectedDate: _selectedDate,
                    focusedDay: _focusedDay,
                    onDateSelected: onDateSelected,
                  ),
                ),
                Expanded(
                  child: TablesByLocation(
                    tables: widget.tables.where((t) =>
                        _selectedDate == null || t.date == _selectedDate),
                    selectedPlace: _selectedPlace,
                    onPlaceSelected: onPlaceSelected,
                  ),
                ),
              ]),
            ),
          ],
        );
      }
    });
  }
}
