import 'package:agendar_cc_flutter/screens/SelectLocation/select_location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

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
          child: ResultsFetcher(),
        )
      ],
    ));
  }
}

class ResultsFetcher extends StatelessWidget {
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
              return Results();
            }
        }
      },
    );
  }
}

class Results extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var filter = IrnFilter(
      serviceId: 1,
      districtId: 15,
    );

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
              return Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IrnTablesDateView(snapshot.data!),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IrnTablesMapView(snapshot.data!),
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
  const IrnTablesDateView(this.tables);

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
    var minDate = markedDatesMap.events.keys
        .reduce((value, element) => element.isBefore(value) ? element : value);
    return Container(
      child: CalendarCarousel<Event>(
        markedDatesMap: markedDatesMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        selectedDateTime: minDate,
        selectedDayBorderColor: Colors.red,
        daysHaveCircularBorder: true,
      ),
    );
  }
}

class IrnTablesMapView extends StatelessWidget {
  final IrnTables tables;
  const IrnTablesMapView(this.tables);

  Set<Marker> toMarkers(IrnTables tables) {
    var l = tables.where((t) => t.gpsLocation != null).map((t) {
      var m = Marker(
        position: LatLng(
          t.gpsLocation!.latitude.toDouble(),
          t.gpsLocation!.longitude.toDouble(),
        ),
        markerId: MarkerId(
          Uuid().v4(),
        ),
      );
      return m;
    });

    return l.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MainlandMap(markers: toMarkers(tables)),
    );
  }
}
