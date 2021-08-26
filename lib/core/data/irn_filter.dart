import 'package:agendar_cc_flutter/core/service_locator.dart';
import 'package:flutter/material.dart';

class IrnFilter {
  final int? serviceId;
  final String? region;
  final int? districtId;
  final int? countyId;
  final String? placeName;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? date;

  IrnFilter({
    this.serviceId,
    this.region,
    this.districtId,
    this.countyId,
    this.placeName,
    this.startTime,
    this.endTime,
    this.startDate,
    this.endDate,
    this.date,
  });

  IrnFilter copyWith({
    int? serviceId,
    String? region,
    int? districtId,
    int? countyId,
    String? placeName,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? date,
  }) {
    return IrnFilter(
      serviceId: serviceId ?? this.serviceId,
      region: region ?? this.region,
      districtId: districtId ?? this.districtId,
      countyId: countyId ?? this.countyId,
      placeName: placeName ?? this.placeName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      date: date ?? this.date,
    );
  }
}

IrnFilter normalizeFilter(
  IrnFilter filter, {
  String? region,
  int? districtId,
  int? countyId,
}) {
  var ref = ServiceLocator.referenceData;
  districtId = region != null &&
          districtId != null &&
          !ref
              .filterDistricts(region: region)
              .map((d) => d.districtId)
              .contains(districtId)
      ? null
      : districtId;
  countyId = region != null &&
          districtId != null &&
          countyId != null &&
          !ref
              .filterCounties(region: region, districtId: districtId)
              .map((c) => c.countyId)
              .contains(countyId)
      ? null
      : countyId;

  if (countyId != null) districtId = ref.county(countyId).districtId;
  if (districtId != null) region = ref.district(districtId).region;

  return IrnFilter(
    serviceId: filter.serviceId,
    region: region,
    districtId: districtId,
    countyId: countyId,
    placeName: filter.placeName,
    startTime: filter.startTime,
    endTime: filter.endTime,
    startDate: filter.startDate,
    endDate: filter.endDate,
    date: filter.date,
  );
}
