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

  if (region != null && region != filter.region) {
    if (districtId != null) {
      if (!ref
          .filterDistricts(region: region)
          .map((d) => d.districtId)
          .contains(districtId)) {
        districtId = null;
      }
    }
    if (countyId != null) {
      if (!ref
          .filterCounties(region: region, districtId: districtId)
          .map((c) => c.countyId)
          .contains(countyId)) {
        countyId = null;
      }
    }
  }

  if (districtId != null && districtId != filter.districtId) {
    region = ref.district(districtId).region;
    if (countyId != null) {
      if (!ref
          .filterCounties(region: region, districtId: districtId)
          .map((c) => c.countyId)
          .contains(countyId)) {
        countyId = null;
      }
    }
  }

  if (countyId != null && countyId != filter.countyId) {
    districtId = ref.county(countyId).districtId;
    region = ref.district(districtId).region;
  }

  if (districtId == null) {
    var districts = ref.filterDistricts(region: region);
    if (districts.length == 1) {
      districtId = districts.first.districtId;
    }
  }

  if (countyId == null) {
    var counties = ref.filterCounties(region: region, districtId: districtId);
    if (counties.length == 1) {
      countyId = counties.first.countyId;
    }
  }

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
