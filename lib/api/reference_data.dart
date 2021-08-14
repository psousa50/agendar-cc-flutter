import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_config.dart';
import '../models.dart';

class ReferenceData {
  final AppConfig _config;
  Iterable<IrnTable>? _irnTables;
  Iterable<IrnService>? _irnServices;
  Iterable<District>? _districts;
  Iterable<County>? _counties;
  Iterable<IrnPlace>? _irnPlaces;

  ReferenceData(this._config);

  Future<Iterable<T>> _readArea<T>(
    String endpoint,
    T mapArea(dynamic map),
  ) async {
    var port = _config.port == null ? '' : ':${_config.port}';
    var url = Uri.parse('${_config.host}$port/api/v1/$endpoint');
    var response = await http.get(url);
    var areas = (json.decode(response.body) as Iterable);
    return areas.map(mapArea);
  }

  Future<Iterable<IrnTable>> _readIrnTables() async {
    return _readArea("irnTables", (d) => IrnTable.fromMap(d));
  }

  Future<Iterable<IrnService>> _readIrnServices() async {
    return _readArea("irnServices", (d) => IrnService.fromMap(d));
  }

  Future<Iterable<District>> _readDistricts() async {
    return _readArea("districts", (d) => District.fromMap(d));
  }

  Future<Iterable<County>> _readCounties() async {
    return _readArea("counties", (d) => County.fromMap(d));
  }

  Future<Iterable<IrnPlace>> _readIrnPlaces() async {
    return _readArea("irnPlaces", (d) => IrnPlace.fromMap(d));
  }

  Future<Iterable<IrnTable>> irnTables() async {
    return _irnTables ?? await _readIrnTables();
  }

  Future<Iterable<IrnService>> irnServices() async {
    return _irnServices ?? await _readIrnServices();
  }

  Future<Iterable<District>> districts() async {
    return _districts ?? await _readDistricts();
  }

  Future<Iterable<County>> counties() async {
    return _counties ?? await _readCounties();
  }

  Future<Iterable<IrnPlace>> irnPlaces() async {
    return _irnPlaces ?? await _readIrnPlaces();
  }

  Future<Iterable<County>> countiesByDistrict(int districtId) async {
    return (await counties()).where((e) => e.districtId == districtId);
  }

  Future<Iterable<IrnPlace>> irnPlacesByCounty(int countyId) async {
    return (await irnPlaces()).where((e) => e.countyId == countyId);
  }
}
