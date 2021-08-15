import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';
import 'service_locator.dart';

typedef AreasDescription = List<AreaDescription>;
typedef Areas = Map<AreaType, AreasDescription>;

enum AreaType {
  District,
  County,
  IrnPlace,
}

class AreaDescription {
  final String id = Uuid().v4();
  final AreaType type;
  final int? parentId;
  final int areaId;
  final String region;
  final String name;
  final GpsLocation? gpsLocation;
  AreasDescription children = [];
  BitmapDescriptor? markerImage;

  AreaDescription({
    required this.type,
    this.parentId,
    required this.areaId,
    required this.region,
    required this.name,
    this.gpsLocation,
    this.markerImage,
  });
}

class AreasManager {
  Map<AreaType, AreasDescription>? _areas;

  var referenceData = ServiceLocator.referenceData;

  AreaDescription _fromDistrict(District d) {
    return AreaDescription(
      type: AreaType.District,
      areaId: d.districtId,
      region: d.region,
      name: d.name,
      gpsLocation: d.gpsLocation,
    );
  }

  AreaDescription _fromCounty(County c) {
    return AreaDescription(
      type: AreaType.County,
      parentId: c.districtId,
      areaId: c.countyId,
      region: "",
      name: c.name,
      gpsLocation: c.gpsLocation,
    );
  }

  AreaDescription _fromIrnPlace(IrnPlace p) {
    return AreaDescription(
      type: AreaType.IrnPlace,
      parentId: p.countyId,
      areaId: 0,
      region: "",
      name: p.name,
      gpsLocation: p.gpsLocation,
    );
  }

  // AreasDescription addMarkerImage(AreasDescription areas) {
  //   var areasWithImages = areas.map((a) {
  //     a.markerImage = textAsBitmap(a.name);
  //     return a;
  //   }).toList();

  //   return Future.wait(areasWithImages);
  // }

  Map<AreaType, AreasDescription> buildAreas() {
    var districtAreas = (referenceData.districts()).map(_fromDistrict).toList();
    var countiesAreas = (referenceData.counties()).map(_fromCounty).toList();
    var irnPlacesAreas =
        (referenceData.irnPlaces()).map(_fromIrnPlace).toList();

    var areas = Areas();
    areas[AreaType.District] = districtAreas;
    areas[AreaType.County] = countiesAreas;
    areas[AreaType.IrnPlace] = irnPlacesAreas;

    return areas;
  }

  AreasDescription districts() {
    return (areas())[AreaType.District] ?? [];
  }

  AreasDescription counties() {
    return (areas())[AreaType.County] ?? [];
  }

  AreasDescription irnPlaces() {
    return (areas())[AreaType.IrnPlace] ?? [];
  }

  AreasDescription countiesByDistrict(int districtId) {
    return (counties()).where((c) => c.parentId == districtId).toList();
  }

  AreasDescription irnPlacesByCounty(int countyId) {
    return (irnPlaces()).where((p) => p.parentId == countyId).toList();
  }

  Areas areas() => _areas ?? buildAreas();
  AreasDescription areasByType(AreaType type) => (areas())[type] ?? [];
}
