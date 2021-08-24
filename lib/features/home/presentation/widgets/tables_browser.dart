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
  String? selectedPlace;

  void selectTable() {
    if (_selectedDate == null || selectedPlace == null) return;

    var filteredTables = widget.tables.where(
      (t) =>
          (_selectedDate == null || t.date == _selectedDate) &&
          (selectedPlace == null || t.placeName == selectedPlace),
    );
    var table = filteredTables.first;
    var tableSelection = IrnTableSelection(
        serviceId: table.serviceId,
        districtId: table.districtId,
        countyId: table.countyId,
        placeName: selectedPlace!,
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
      setState(() {
        _selectedDate = _selectedDate == date ? null : date;
        _focusedDay = focusedDay;
      });
      selectTable();
    }

    void onPlaceSelected(String place) {
      setState(() {
        selectedPlace = selectedPlace == place ? null : place;
      });
      selectTable();
    }

    return Column(
      children: [
        TablesByDateView(
          tables: widget.tables.where(
            (t) => selectedPlace == null || t.placeName == selectedPlace,
          ),
          selectedDate: _selectedDate,
          focusedDay: _focusedDay,
          onDateSelected: onDateSelected,
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TablesByLocation(
            tables: widget.tables
                .where((t) => _selectedDate == null || t.date == _selectedDate),
            selectedPlace: selectedPlace,
            onPlaceSelected: onPlaceSelected,
          ),
        )),
      ],
    );
  }
}
