import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:agendar_cc_flutter/screens/SelectLocation/select_location_screen.dart';

import '../../models.dart';
import '../../service_locator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: 50,
          color: Colors.yellow,
        ),
        Expanded(
          child: HomeScreenView(),
        )
      ],
    ));
  }
}

class HomeScreenView extends StatelessWidget {
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
              return HomeScreenViewResults();
            }
        }
      },
    );
  }
}

class HomeScreenViewResults extends StatefulWidget {
  @override
  _HomeScreenViewResultsState createState() => _HomeScreenViewResultsState();
}

class _HomeScreenViewResultsState extends State<HomeScreenViewResults> {
  DateTime? selectedDate;
  String? selectedPlace;

  @override
  Widget build(BuildContext context) {
    var filter = IrnFilter(
      serviceId: 4,
      districtId: 15,
    );

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
      future: ServiceLocator.irnTablesFetcher.fetchIrnTables(filter),
      builder: (BuildContext context, AsyncSnapshot<IrnTables> snapshot) {
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
              var tables = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IrnTablesDateView(
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
                    child: IrnTablesMapView(
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
            }
        }
      },
    ));
  }
}

Map<T, List<IrnTable>> groupTables<T>(
    IrnTables tables, T groupedBy(IrnTable t)) {
  Map<T, List<IrnTable>> grouped = {};
  tables.forEach((t) {
    var key = groupedBy(t);
    if (!grouped.containsKey(key)) {
      grouped[key] = [];
    }
    grouped[key]!.add(t);
  });

  return grouped;
}

class IrnTablesDateView extends StatelessWidget {
  final IrnTables tables;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const IrnTablesDateView({
    required this.tables,
    required this.onDateSelected,
    this.selectedDate,
  });

  DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

  @override
  Widget build(BuildContext context) {
    var groupedTables = groupTables(tables, (IrnTable t) => t.date);
    var minDate = (groupedTables.keys.length > 0
        ? groupedTables.keys.reduce(
            (value, element) => element.isBefore(value) ? element : value)
        : null);
    var maxDate = (groupedTables.keys.length > 0
        ? groupedTables.keys.reduce(
            (value, element) => element.isAfter(value) ? element : value)
        : null);
    return Container(
      child: TableCalendar(
        selectedDayPredicate: (date) => dateOnly(date) == selectedDate,
        shouldFillViewport: true,
        onDaySelected: (selectedDay, focusedDay) =>
            onDateSelected(dateOnly(selectedDay)),
        firstDay: minDate ?? DateTime.now(),
        lastDay: maxDate ?? DateTime.now(),
        focusedDay: selectedDate ?? minDate ?? DateTime.now(),
        eventLoader: (DateTime date) {
          return groupedTables[dateOnly(date)] ?? [];
        },
        calendarFormat: CalendarFormat.month,
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

class IrnTablesMapView extends StatelessWidget {
  final IrnTables tables;
  final Function(String) onPlaceSelected;

  const IrnTablesMapView({
    required this.tables,
    required this.onPlaceSelected,
  });

  Set<Marker> toMarkers(IrnTables tables) {
    var groupedTables = groupTables(
      tables.where((t) => t.gpsLocation != null),
      (t) => t.placeName,
    );
    var markers = groupedTables.keys.map((k) {
      var t = groupedTables[k]!.first;
      var position = LatLng(
        t.gpsLocation!.latitude.toDouble(),
        t.gpsLocation!.longitude.toDouble(),
      );
      return Marker(
        position: position,
        markerId: MarkerId(
          Uuid().v4(),
        ),
        onTap: () => onPlaceSelected(t.placeName),
      );
    });
    return markers.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainlandMap(markers: toMarkers(tables)),
    );
  }
}
