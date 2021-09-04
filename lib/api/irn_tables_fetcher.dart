import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../core/services/app_config.dart';
import '../core/data/irn_filter.dart';
import '../core/data/models.dart';

class IrnTablesFetcher {
  final AppConfig _config;

  IrnTablesFetcher(this._config);

  String? formatDate(DateTime? d) {
    return d?.toIso8601String().substring(0, 10);
  }

  String? formatTimeOfDay(TimeOfDay? t) {
    return t != null ? '${t.hour}:${t.minute}:00' : null;
  }

  Future<Iterable<IrnTable>> fetchIrnTables(IrnFilter filter) async {
    var queryParameters = {
      'serviceId': filter.serviceId?.toString(),
      'region': filter.region,
      'districtId': filter.districtId?.toString(),
      'countyId': filter.countyId?.toString(),
      'placeName': filter.placeName,
      'startDate': formatDate(filter.startDate),
      'endDate': formatDate(filter.endDate),
      'startTime': formatTimeOfDay(filter.startTime),
      'endTime': formatTimeOfDay(filter.endTime),
    }..removeWhere((key, value) => value == null);

    var url = Uri(
        scheme: _config.schema,
        host: _config.host,
        port: _config.port,
        path: "/api/v1/irnTables",
        queryParameters: queryParameters);
    var response = await http.get(url);
    var tablesJson = json.decode(response.body);

    var tables = tablesJson.map((t) => IrnTable.fromMap(t));

    return tables;
  }
}
