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

  void selectTable(DateTime selectedDate, String selectedPlace) {
    var filteredTables = widget.tables.where(
      (t) => t.date == selectedDate && t.placeName == selectedPlace,
    );
    var table = filteredTables.first;
    var tableSelection = IrnTableSelection(
      serviceId: table.serviceId,
      districtId: table.districtId,
      countyId: table.countyId,
      placeName: selectedPlace,
      date: selectedDate,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SelectIrnTable(
                tables: filteredTables.filterBy(tableSelection),
                tableSelection: tableSelection,
              )),
    );
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

    if (newSelectedDate != null && _selectedPlace != null) {
      selectTable(newSelectedDate, _selectedPlace!);
    }
  }

  void onPlaceSelected(String place) {
    var newSelectedPlace = _selectedPlace == place ? null : place;

    setState(() {
      _selectedPlace = newSelectedPlace;
      _focusedDay = null;
    });

    if (newSelectedPlace != null && _selectedDate != null) {
      selectTable(_selectedDate!, newSelectedPlace);
    }
  }

  @override
  Widget build(BuildContext context) {
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
