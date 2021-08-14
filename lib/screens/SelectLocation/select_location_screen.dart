import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../service_locator.dart';
import '../../models.dart';

class SelectLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ServiceLocator.referenceData.irnTables(),
        builder: (BuildContext context, AsyncSnapshot<IrnTables> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return MainlandMap(markers: Set());
            default:
              if (snapshot.hasError)
                return MainlandMap(markers: Set());
              else {
                var data = snapshot.data!;
                var validData = data.where((d) => d.gpsLocation != null);
                var markers = validData
                    .map(
                      (d) => Marker(
                        markerId: MarkerId(Uuid().v4()),
                        position: LatLng(
                          d.gpsLocation!.latitude,
                          d.gpsLocation!.longitude,
                        ),
                        // icon: d.markerImage ?? BitmapDescriptor.defaultMarker,
                      ),
                    )
                    .toSet();
                return MainlandMap(markers: markers);
              }
          }
        });
  }
}

class MainlandMap extends StatelessWidget {
  final Set<Marker> markers;
  const MainlandMap({
    required this.markers,
  });

  LatLngBounds calcBounds() {
    if (markers.length == 0) {
      return LatLngBounds(
        southwest: LatLng(37.067410, -9.624353),
        northeast: LatLng(42.205927, -6.182315),
      );
    }
    var minLat = markers
        .reduce(
            (min, m) => m.position.latitude < min.position.latitude ? m : min)
        .position
        .latitude;
    var maxLat = markers
        .reduce(
            (max, m) => m.position.latitude > max.position.latitude ? m : max)
        .position
        .latitude;
    var minLng = markers
        .reduce(
            (min, m) => m.position.longitude < min.position.longitude ? m : min)
        .position
        .longitude;
    var maxLng = markers
        .reduce(
            (max, m) => m.position.longitude > max.position.longitude ? m : max)
        .position
        .longitude;
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bounds = calcBounds();
    var target = LatLng(
      (bounds.northeast.latitude + bounds.southwest.latitude) / 2.0,
      (bounds.northeast.longitude + bounds.southwest.longitude) / 2.0,
    );

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: target,
        zoom: 7.3,
      ),
      cameraTargetBounds: CameraTargetBounds(
        bounds,
      ),
      markers: markers,
      circles: {
        Circle(
          circleId: CircleId("0"),
          center: LatLng(target.latitude, target.longitude),
          radius: 1000,
        ),
        Circle(
          circleId: CircleId("1"),
          center: LatLng(bounds.southwest.latitude, bounds.southwest.longitude),
          radius: 1000,
        ),
        Circle(
          circleId: CircleId("2"),
          center: LatLng(bounds.northeast.latitude, bounds.northeast.longitude),
          radius: 1000,
        ),
      },
      myLocationEnabled: true,
    );
  }
}
