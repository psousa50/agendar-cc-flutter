import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/app_config.dart';
import '../core/data/models.dart';

class ReferenceData {
  final AppConfig _config;
  Iterable<Region> _regions = [];
  Iterable<IrnService>? _irnServices;
  Iterable<District>? _districts;
  Iterable<County>? _counties;
  Iterable<IrnPlace>? _irnPlaces;
  var _staticDataFetched = false;

  ReferenceData(this._config);

  Iterable<Region> regions() {
    return _regions;
  }

  Iterable<IrnService> irnServices() {
    return _irnServices ?? [];
  }

  Iterable<District> districts() {
    return _districts ?? [];
  }

  Iterable<County> counties() {
    return _counties ?? [];
  }

  Iterable<IrnPlace> irnPlaces() {
    return _irnPlaces ?? [];
  }

  IrnService irnService(int serviceId) {
    return irnServices().firstWhere((e) => e.serviceId == serviceId);
  }

  Region region(String regionId) {
    return regions().firstWhere((e) => e.regionId == regionId);
  }

  District district(int districtId) {
    return districts().firstWhere((e) => e.districtId == districtId);
  }

  County county(int countyId) {
    return counties().firstWhere((e) => e.countyId == countyId);
  }

  IrnPlace irnPlace(String name) {
    return irnPlaces().firstWhere((e) => e.name == name);
  }

  Iterable<District> filterDistricts({String? region}) {
    return districts().where((d) => region == null || d.region == region);
  }

  Iterable<County> filterCounties({String? region, int? districtId}) {
    Iterable<District> districtsForRegion = districtId == null && region != null
        ? filterDistricts(region: region)
        : [];
    var districtIdsForRegion = districtsForRegion.map((d) => d.districtId);
    return districtId != null
        ? counties().where((c) => c.districtId == districtId)
        : region != null
            ? counties()
                .where((c) => districtIdsForRegion.contains(c.districtId))
            : counties();
  }

  Future<Iterable<T>> _readArea<T>(
    String endpoint,
    T mapArea(dynamic map),
  ) async {
    var url = Uri(
      scheme: _config.schema,
      host: _config.host,
      port: _config.port,
      path: 'api/v1/$endpoint',
    );
    var response = await http.get(url);
    var areas = (json.decode(response.body) as Iterable);
    return areas.map(mapArea);
  }

  Future<void> _fetchStaticData() async {
    _regions = [
      Region(regionId: "Continente", name: "Continente"),
      Region(regionId: "Acores", name: "Açores"),
      Region(regionId: "Madeira", name: "Madeira"),
    ];

    _irnServices = await _readArea("irnServices", (d) => IrnService.fromMap(d));
    _districts = await _readArea("districts", (d) => District.fromMap(d));
    _counties = await _readArea("counties", (d) => County.fromMap(d));
    _irnPlaces = await _readArea("irnPlaces", (d) => IrnPlace.fromMap(d));
    _staticDataFetched = true;
  }

  Future<void> fetchAll() async {
    if (!_staticDataFetched) await _fetchStaticData();
  }

  double _manhattanDistance(District d, GpsLocation l) {
    return (d.gpsLocation!.latitude - l.latitude).abs() +
        (d.gpsLocation!.longitude - l.longitude).abs();
  }

  int getCloserDistrictTo(GpsLocation gpsLocation) {
    return districts()
        .where((d) => d.gpsLocation != null)
        .reduce((value, element) => _manhattanDistance(element, gpsLocation) <
                _manhattanDistance(value, gpsLocation)
            ? element
            : value)
        .districtId;
  }
}
