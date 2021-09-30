import 'package:flutter/material.dart';

import '../../../../core/data/models.dart';
import '../../../../core/service_locator.dart';
import '../../../select_irn_table/presentation/select_irn_table.dart';

class CurrentSelection extends StatelessWidget {
  final IrnTables tables;
  final DateTime? selectedDate;
  final String? selectedPlace;

  const CurrentSelection(
    this.tables,
    this.selectedDate,
    this.selectedPlace,
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    void selectTable() {
      var filteredTables = tables.where(
        (t) => t.date == selectedDate && t.placeName == selectedPlace,
      );
      var table = filteredTables.first;
      var tableSelection = IrnTableSelection(
        serviceId: table.serviceId,
        districtId: table.districtId,
        countyId: table.countyId,
        placeName: selectedPlace!,
        date: selectedDate!,
      );

      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SelectIrnTable(
                  tables: filteredTables.filterBy(tableSelection),
                  tableSelection: tableSelection,
                )),
      );
    }

    var countyId = selectedPlace == null
        ? null
        : ServiceLocator.referenceData.irnPlace(selectedPlace!).countyId;
    var countyName = countyId == null
        ? ""
        : ServiceLocator.referenceData.county(countyId).name;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          selectedDate?.toIso8601String().substring(0, 10) ??
                              "",
                          style: theme.textTheme.subtitle1,
                        ),
                        Text(
                          countyName,
                          style: theme.textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                      onPressed: (selectedDate != null && selectedPlace != null)
                          ? selectTable
                          : null,
                      child: Text('Agendar')),
                ],
              ),
            ),
          ],
        ));
  }
}
