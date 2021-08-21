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
    return Container(
        child: Column(
      children: [
        Container(
          height: 50,
          color: Colors.yellow,
        ),
        Consumer<TablesFilter>(
          builder: (_, tablesFilter, __) => Expanded(
            child: HomePageView(tablesFilter),
          ),
        )
      ],
    ));
  }
}

class HomePageView extends StatelessWidget {
  final TablesFilter tablesFilter;
  const HomePageView(this.tablesFilter);

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
              return HomeScreenViewResults(tablesFilter);
            }
        }
      },
    );
  }
}

class HomeScreenViewResults extends StatefulWidget {
  final TablesFilter tablesFilter;
  const HomeScreenViewResults(this.tablesFilter);

  @override
  _HomeScreenViewResultsState createState() => _HomeScreenViewResultsState();
}

class _HomeScreenViewResultsState extends State<HomeScreenViewResults> {
  DateTime? selectedDate;
  String? selectedPlace;

  @override
  Widget build(BuildContext context) {
    void onDateSelected(DateTime date) {
      setState(() {
        selectedDate = date;
      });
    }

    void onPlaceSelected(String place) {
      setState(() {
        selectedPlace = place;
      });
    }

    return Container(
      child: FutureBuilder(
          future: ServiceLocator.irnTablesFetcher
              .fetchIrnTables(widget.tablesFilter.filter),
          builder: (BuildContext context, AsyncSnapshot<IrnTables> snapshot) {
            var tables = snapshot.data ?? [];
            return Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TablesByDateView(
                    tables: selectedPlace == null
                        ? tables
                        : tables.where(
                            (t) => t.placeName == selectedPlace,
                          ),
                    onDateSelected: onDateSelected,
                    selectedDate: selectedDate,
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TablesByLocation(
                    tables: selectedDate == null
                        ? tables
                        : tables.where(
                            (t) => t.date == selectedDate,
                          ),
                    onPlaceSelected: onPlaceSelected,
                  ),
                )),
              ],
            );
          }),
    );
  }
}
