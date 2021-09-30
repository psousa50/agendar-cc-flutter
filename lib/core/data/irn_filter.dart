import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/extensions.dart';
import '../service_locator.dart';

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

  const IrnFilter({
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

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'region': region,
      'districtId': districtId,
      'countyId': countyId,
      'placeName': placeName,
      'startTime': startTime?.toSlotHHMMSS(),
      'endTime': endTime?.toSlotHHMMSS(),
      'startDate': startDate?.millisecondsSinceEpoch,
      'endDate': endDate?.millisecondsSinceEpoch,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  static DateTime? safeFromMilliseconds(int? mili) {
    return mili != null ? DateTime.fromMillisecondsSinceEpoch(mili) : null;
  }

  static TimeOfDay? safeTimeOfDayFromSlot(String? slot) {
    return slot != null ? timeOfDayFromSlot(slot) : null;
  }

  factory IrnFilter.fromMap(Map<String, dynamic> map) {
    return IrnFilter(
      serviceId: map['serviceId'],
      region: map['region'],
      districtId: map['districtId'],
      countyId: map['countyId'],
      placeName: map['placeName'],
      startTime: safeTimeOfDayFromSlot(map['startTime']),
      endTime: safeTimeOfDayFromSlot(map['endTime']),
      startDate: safeFromMilliseconds(map['startDate']),
      endDate: safeFromMilliseconds(map['endDate']),
      date: safeFromMilliseconds(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IrnFilter.fromJson(String source) =>
      IrnFilter.fromMap(json.decode(source));

  IrnFilter clear() {
    return IrnFilter(
      serviceId: serviceId,
      region: null,
      districtId: null,
      countyId: null,
      placeName: null,
      startTime: null,
      endTime: null,
      startDate: null,
      endDate: null,
      date: null,
    );
  }

  String formatDate(DateTime date) {
    return date.toIso8601String().substring(0, 10);
  }

  String formatTime(TimeOfDay time) {
    return time.toSlotHHMM();
  }

  String countyDescription() {
    var ref = ServiceLocator.referenceData;
    var region = this.region;
    var countyId = this.countyId;
    var county = countyId != null ? ref.county(countyId) : null;
    var districtId = this.districtId ??
        county?.districtId ??
        (countyId != null ? ref.county(countyId).districtId : null);
    var district = districtId != null ? ref.district(districtId) : null;
    var regionName = region != null ? " - ${ref.region(region).name}" : "";
    var districtName =
        district != null ? district.name : "(Todos os distritos$regionName)";
    if (county != null && county.name != districtName) {
      districtName = "$districtName - ${county.name}";
    }

    return districtName;
  }

  String dateRangeDescription() {
    var startDate = this.startDate;
    var endDate = this.endDate;
    return startDate != null && endDate == null
        ? "A partir de ${formatDate(startDate)}"
        : startDate == null && endDate != null
            ? "Até ${formatDate(endDate)}"
            : startDate != null && endDate != null
                ? startDate == endDate
                    ? "No dia ${formatDate(startDate)}"
                    : "De ${formatDate(startDate)} até ${formatDate(endDate)}"
                : "Em qualquer altura";
  }

  String timeRangeDescription() {
    var startTime = this.startTime;
    var endTime = this.endTime;
    return startTime != null && endTime == null
        ? "A partir das ${formatTime(startTime)}"
        : startTime == null && endTime != null
            ? "Até às ${formatTime(endTime)}"
            : startTime != null && endTime != null
                ? startTime == endTime
                    ? "Às ${formatTime(startTime)}"
                    : "Das ${formatTime(startTime)} às ${formatTime(endTime)}"
                : "Em qualquer altura";
  }

  String locationDescription() {
    return "${countyDescription()}";
  }

  String serviceDescription() {
    var ref = ServiceLocator.referenceData;
    return ref.irnService(this.serviceId!).name;
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

  if (region == null && filter.region != null) {
    districtId = null;
    countyId = null;
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

  if (districtId == null && filter.districtId != null) {
    countyId = null;
  }

  if (countyId != null && countyId != filter.countyId) {
    districtId = ref.county(countyId).districtId;
    region = ref.district(districtId).region;
  }

  if (districtId == null && region != null) {
    var districts = ref.filterDistricts(region: region);
    if (districts.length == 1) {
      districtId = districts.first.districtId;
    }
  }

  if (countyId == null && districtId != null) {
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
