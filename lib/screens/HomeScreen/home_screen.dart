import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
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
      districtId: 12,
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

class IrnTablesDateView extends StatelessWidget {
  final IrnTables tables;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;

  const IrnTablesDateView({
    required this.tables,
    required this.onDateSelected,
    this.selectedDate,
  });

  static Widget _eventIcon(String day) => CircleAvatar(
        backgroundColor: Colors.lightBlue,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  EventList<Event> toDatesMap(IrnTables tables) {
    Map<DateTime, List<Event>> events = {};
    tables.forEach((t) {
      var key = t.date;
      if (!events.containsKey(key)) {
        events[key] = [];
      }
      events[key]!.add(Event(
        date: t.date,
        icon: _eventIcon(t.date.day.toString()),
      ));
    });

    return EventList<Event>(events: events);
  }

  @override
  Widget build(BuildContext context) {
    var markedDatesMap = toDatesMap(tables);
    var minDate = selectedDate ??
        (markedDatesMap.events.keys.length > 0
            ? markedDatesMap.events.keys.reduce(
                (value, element) => element.isBefore(value) ? element : value)
            : null);
    return Container(
      child: CalendarCarousel<Event>(
        markedDatesMap: markedDatesMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        onDayPressed: (date, _) => onDateSelected(date),
        selectedDateTime: minDate,
        selectedDayBorderColor: Colors.red,
        daysHaveCircularBorder: true,
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
    return tables
        .where((t) => t.gpsLocation != null)
        .map((t) => Marker(
              position: LatLng(
                t.gpsLocation!.latitude.toDouble(),
                t.gpsLocation!.longitude.toDouble(),
              ),
              markerId: MarkerId(
                Uuid().v4(),
              ),
              onTap: () => onPlaceSelected(t.placeName),
            ))
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainlandMap(markers: toMarkers(tables)),
    );
  }
}
