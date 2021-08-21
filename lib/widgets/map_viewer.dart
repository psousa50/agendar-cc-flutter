import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewer extends StatelessWidget {
  final Set<Marker> markers;
  const MapViewer({
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
        zoom: 10.0,
      ),
      cameraTargetBounds: CameraTargetBounds(
        bounds,
      ),
      markers: markers,
    );
  }
}
