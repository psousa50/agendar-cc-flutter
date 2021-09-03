import 'package:geolocator/geolocator.dart';

import 'data/models.dart';

class GeoLocatorService {
  Future<GpsLocation?> getLocation() async {
    Position? position;
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        position = await Geolocator.getCurrentPosition();
      }
    }
    return position != null
        ? GpsLocation(
            latitude: position.latitude, longitude: position.longitude)
        : null;
  }
}
