import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models.dart';

class ReferenceData {
  final AppConfig _config;
  Iterable<String> _regions = ["Continente", "Acores", "Madeira"];
  Iterable<IrnService>? _irnServices;
  Iterable<District>? _districts;
  Iterable<County>? _counties;
  Iterable<IrnPlace>? _irnPlaces;
  var _staticDataFetched = false;

  ReferenceData(this._config);

  Iterable<String> regions() {
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

  District district(int districtId) {
    return districts().firstWhere((e) => e.districtId == districtId);
  }

  County county(int countyId) {
    return counties().firstWhere((e) => e.countyId == countyId);
  }

  IrnPlace irnPlace(String name) {
    return irnPlaces().firstWhere((e) => e.name == name);
  }

  Iterable<District> districtByRegion(String region) {
    return districts().where((e) => e.region == region);
  }

  Iterable<County> countyByDistrictId(int districtId) {
    return counties().where((e) => e.districtId == districtId);
  }

  Iterable<IrnPlace> irnPlacesByCountyId(int countyId) {
    return irnPlaces().where((e) => e.countyId == countyId);
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
    _regions = ["Continente", "Acores", "Madeira"];
    _irnServices = await _readArea("irnServices", (d) => IrnService.fromMap(d));
    _districts = await _readArea("districts", (d) => District.fromMap(d));
    _counties = await _readArea("counties", (d) => County.fromMap(d));
    _irnPlaces = await _readArea("irnPlaces", (d) => IrnPlace.fromMap(d));
    _staticDataFetched = true;
  }

  Future<void> fetchAll() async {
    if (!_staticDataFetched) await _fetchStaticData();
  }
}
