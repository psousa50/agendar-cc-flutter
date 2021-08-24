import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/data/models.dart';
import '../../../../widgets/map_viewer.dart';

class TablesByLocation extends StatefulWidget {
  final IrnTables tables;
  final String? selectedPlace;
  final Function(String) onPlaceSelected;

  const TablesByLocation({
    required this.tables,
    required this.selectedPlace,
    required this.onPlaceSelected,
  });

  @override
  _TablesByLocationState createState() => _TablesByLocationState();
}

class _TablesByLocationState extends State<TablesByLocation> {
  Set<Marker> toMarkers(IrnTables tables) {
    Map<String, List<IrnTable>> groupedTables = groupBy(
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
        consumeTapEvents: true,
        icon: t.placeName == widget.selectedPlace
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarker,
        markerId: MarkerId(
          Uuid().v4(),
        ),
        onTap: () => widget.onPlaceSelected(t.placeName),
      );
    });
    return markers.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapViewer(markers: toMarkers(widget.tables)),
    );
  }
}
