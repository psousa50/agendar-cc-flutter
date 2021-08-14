import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';
import 'helpers.dart';
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

  Future<AreasDescription> addMarkerImage(AreasDescription areas) {
    var areasWithImages = areas.map((a) async {
      a.markerImage = await textAsBitmap(a.name);
      return a;
    }).toList();

    return Future.wait(areasWithImages);
  }

  Future<Map<AreaType, AreasDescription>> buildAreas() async {
    var districtAreas =
        (await referenceData.districts()).map(_fromDistrict).toList();
    var countiesAreas =
        (await referenceData.counties()).map(_fromCounty).toList();
    var irnPlacesAreas =
        (await referenceData.irnPlaces()).map(_fromIrnPlace).toList();

    var areas = Areas();
    areas[AreaType.District] = await addMarkerImage(districtAreas);
    areas[AreaType.County] = await addMarkerImage(countiesAreas);
    areas[AreaType.IrnPlace] = await addMarkerImage(irnPlacesAreas);

    return Future.value(areas);
  }

  Future<AreasDescription> districts() async {
    return (await areas())[AreaType.District] ?? [];
  }

  Future<AreasDescription> counties() async {
    return (await areas())[AreaType.County] ?? [];
  }

  Future<AreasDescription> irnPlaces() async {
    return (await areas())[AreaType.IrnPlace] ?? [];
  }

  Future<AreasDescription> countiesByDistrict(int districtId) async {
    return (await counties()).where((c) => c.parentId == districtId).toList();
  }

  Future<AreasDescription> irnPlacesByCounty(int countyId) async {
    return (await irnPlaces()).where((p) => p.parentId == countyId).toList();
  }

  Future<Areas> areas() async => _areas ?? await buildAreas();
  Future<AreasDescription> areasByType(AreaType type) async =>
      (await areas())[type] ?? [];
}
