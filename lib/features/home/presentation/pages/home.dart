import 'package:agendar_cc_flutter/features/select_irn_table/presentation/select_irn_table.dart';
import 'package:agendar_cc_flutter/widgets/page_with_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/models.dart';
import '../../../../core/tables_filter.dart';
import '../../../../core/service_locator.dart';
import '../widgets/tables_by_date.dart';
import '../widgets/tables_by_location.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      title: "Mesas",
      child: Consumer<TablesFilter>(
        builder: (_, tablesFilter, __) =>
            Container(child: HomePageView(tablesFilter)),
      ),
    );
  }
}

class HomePageView extends StatelessWidget {
  final TablesFilter tablesFilter;
  const HomePageView(this.tablesFilter);

  Widget buildInfoRow(String text) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text(text)],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(Icons.navigate_next)],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ServiceLocator.referenceData.fetchAll(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            default:
              if (snapshot.hasError) {
                return Container(child: Text(snapshot.error.toString()));
              } else {
                return Container(
                  child: Column(
                    children: [
                      buildInfoRow(tablesFilter.serviceDescription()),
                      buildInfoRow(tablesFilter.locationDescription()),
                      FutureBuilder(
                          future: ServiceLocator.irnTablesFetcher
                              .fetchIrnTables(tablesFilter.filter),
                          builder: (BuildContext context,
                              AsyncSnapshot<IrnTables> snapshot) {
                            var tables = snapshot.data ?? [];
                            return Expanded(child: TablesSelection(tables));
                          }),
                    ],
                  ),
                );
              }
          }
        });
  }
}

class TablesSelection extends StatefulWidget {
  final IrnTables tables;
  const TablesSelection(this.tables);

  @override
  _TablesSelectionState createState() => _TablesSelectionState();
}

class _TablesSelectionState extends State<TablesSelection> {
  DateTime? selectedDate;
  IrnTables filteredTables = [];

  @override
  void didUpdateWidget(covariant TablesSelection oldWidget) {
    filteredTables = widget.tables;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    void onDateSelected(DateTime date) {
      setState(() {
        selectedDate = selectedDate == date ? null : date;
        filteredTables = selectedDate == null
            ? widget.tables
            : widget.tables.where((t) => t.date == selectedDate);
      });
    }

    void onPlaceSelected(String place) {
      if (selectedDate == null) return;

      var table = filteredTables.where((t) => t.placeName == place);
      var tableSelection = IrnTableSelection(
          serviceId: table.first.serviceId,
          districtId: table.first.districtId,
          countyId: table.first.countyId,
          placeName: place,
          date: selectedDate!);
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => SelectIrnTable(
                  tables: filteredTables.filterBy(tableSelection),
                  tableSelection: tableSelection,
                )),
      );
    }

    return Container(
      child: Column(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TablesByDateView(
              tables: widget.tables,
              onDateSelected: onDateSelected,
              selectedDate: selectedDate,
            ),
          )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TablesByLocation(
              tables: filteredTables,
              onPlaceSelected: onPlaceSelected,
            ),
          )),
        ],
      ),
    );
  }
}
