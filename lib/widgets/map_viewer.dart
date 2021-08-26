import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension LatLngBoundsExtensions on LatLngBounds {
  double get left => northeast.longitude;
  double get right => southwest.longitude;
  double get top => northeast.latitude;
  double get bottom => southwest.latitude;
  double get width => (southwest.longitude - northeast.longitude).abs();
  double get height => (northeast.latitude - southwest.latitude).abs();

  LatLngBounds fromLTRB(double left, double top, double right, double bottom) {
    var minLat = min(top, bottom);
    var maxLat = max(top, bottom);
    return LatLngBounds(
      northeast: LatLng(maxLat, left),
      southwest: LatLng(minLat, right),
    );
  }

  LatLng center() {
    return LatLng(
      (northeast.latitude + southwest.latitude) / 2.0,
      (northeast.longitude + southwest.longitude) / 2.0,
    );
  }

  LatLngBounds ensureMinimumSize(double minSize) {
    double dx = max(0, minSize - width);
    double dy = max(0, minSize - height);
    return dx == 0 && dy == 0 ? this : inflate(dx, dy);
  }

  LatLngBounds inflate(double dx, double dy) {
    return fromLTRB(
      northeast.longitude - dx,
      northeast.latitude + dy,
      southwest.longitude + dx,
      southwest.latitude - dy,
    );
  }

  LatLngBounds inflateByPercentage(double percentage) {
    return inflate(width * percentage, height * percentage);
  }

  bool containsBox(LatLngBounds another) {
    return left <= another.left &&
        left + width >= another.left + another.width &&
        top <= another.top &&
        top + height >= another.top + another.height;
  }
}

class MapViewer extends StatefulWidget {
  final Set<Marker> markers;
  const MapViewer({
    required this.markers,
  });

  @override
  _MapViewerState createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> {
  static LatLngBounds defaultBounds = LatLngBounds(
    southwest: LatLng(37.067410, -9.624353),
    northeast: LatLng(42.205927, -6.182315),
  );

  final Completer<GoogleMapController> _controller = Completer();

  LatLngBounds? previousBounds;

  LatLngBounds? calcBounds(Set<Marker> markers) {
    LatLngBounds? bounds;
    if (markers.length > 0) {
      var lats = markers.map((m) => m.position.latitude);
      var lngs = markers.map((m) => m.position.longitude);
      double minLat = lats.reduce(min);
      double maxLat = lats.reduce(max);
      double minLng = lngs.reduce(min);
      double maxLng = lngs.reduce(max);
      bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
    }

    return bounds;
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void updateCamera() async {
    var c = await _controller.future;
    var vr = await c.getVisibleRegion();
    var bounds = calcBounds(widget.markers) ?? defaultBounds;

    bounds = bounds.inflateByPercentage(0.1);
    bounds = bounds.ensureMinimumSize(0.005);

    var wantedWidth = bounds.width;
    var wantedHeight = bounds.height;

    var currentWidth = vr.width;
    var currentHeight = vr.height;

    var k = 2 *
        ((wantedHeight > wantedWidth)
            ? wantedHeight / currentHeight
            : wantedWidth / currentWidth);
    var z = k.abs() > 0.000001 ? log(1 / k) / ln2 : 0;

    if (z.abs() > 0.8) {
      var oldZoom = await c.getZoomLevel();
      var zoom = oldZoom + z;
      print("zoom: $zoom");
      if (zoom < 15) {
        var target = bounds.center();
        c.animateCamera(CameraUpdate.newLatLngZoom(target, zoom));
        c.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      }
    }
  }

  @override
  void didUpdateWidget(covariant MapViewer oldWidget) {
    updateCamera();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var bounds = calcBounds(widget.markers) ?? defaultBounds;
    var target = bounds.center();

    return GoogleMap(
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      initialCameraPosition: CameraPosition(
        target: target,
      ),
      cameraTargetBounds: CameraTargetBounds(
        bounds,
      ),
      markers: widget.markers,
      onMapCreated: onMapCreated,
    );
  }
}
