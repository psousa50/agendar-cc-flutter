import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../select_irn_table/presentation/select_irn_table.dart';
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

  void selectTable() {
    if (_selectedDate == null || _selectedPlace == null) return;

    var filteredTables = widget.tables.where(
      (t) =>
          (_selectedDate == null || t.date == _selectedDate) &&
          (_selectedPlace == null || t.placeName == _selectedPlace),
    );
    var table = filteredTables.first;
    var tableSelection = IrnTableSelection(
        serviceId: table.serviceId,
        districtId: table.districtId,
        countyId: table.countyId,
        placeName: _selectedPlace!,
        date: _selectedDate!);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SelectIrnTable(
                tables: filteredTables.filterBy(tableSelection),
                tableSelection: tableSelection,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    void onDateSelected(DateTime date, DateTime focusedDay) {
      if (_selectedDate != date &&
          widget.tables.where((t) => t.date == date).isEmpty) {
        return;
      }

      setState(() {
        _selectedDate = _selectedDate == date ? null : date;
        _focusedDay = focusedDay;
      });
      // if (_selectedDate != null) {
      //   var distinctPlaces = widget.tables
      //       .where((t) => _selectedDate == null || t.date == _selectedDate)
      //       .map((t) => t.placeName)
      //       .toSet();
      //   if (distinctPlaces.length == 1) _selectedPlace = distinctPlaces.first;
      // }
      selectTable();
    }

    void onPlaceSelected(String place) {
      setState(() {
        _selectedPlace = _selectedPlace == place ? null : place;
      });
      // if (_selectedPlace != null) {
      //   var distinctDates = widget.tables
      //       .where(
      //           (t) => _selectedPlace == null || t.placeName == _selectedPlace)
      //       .map((t) => t.date)
      //       .toSet();
      //   if (distinctDates.length == 1) _selectedDate = distinctDates.first;
      // }
      selectTable();
    }

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * .3),
          child: TablesByDateView(
            tables: widget.tables.where(
              (t) => _selectedPlace == null || t.placeName == _selectedPlace,
            ),
            selectedDate: _selectedDate,
            focusedDay: _focusedDay,
            onDateSelected: onDateSelected,
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TablesByLocation(
            tables: widget.tables
                .where((t) => _selectedDate == null || t.date == _selectedDate),
            selectedPlace: _selectedPlace,
            onPlaceSelected: onPlaceSelected,
          ),
        )),
      ],
    );
  }
}
