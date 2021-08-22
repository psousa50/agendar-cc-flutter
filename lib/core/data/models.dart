import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class GpsLocation {
  final double latitude;
  final double longitude;
  GpsLocation({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory GpsLocation.fromMap(Map<String, dynamic> map) {
    return GpsLocation(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GpsLocation.fromJson(String source) =>
      GpsLocation.fromMap(json.decode(source));
}

class IrnService {
  final int serviceId;
  final String name;

  IrnService({
    required this.serviceId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'name': name,
    };
  }

  factory IrnService.fromMap(Map<String, dynamic> map) {
    return IrnService(
      serviceId: map['serviceId'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory IrnService.fromJson(String source) =>
      IrnService.fromMap(json.decode(source));
}

typedef Districts = Iterable<District>;

class District {
  final int districtId;
  final String region;
  final String name;
  final GpsLocation? gpsLocation;
  BitmapDescriptor? image;

  District({
    required this.districtId,
    required this.region,
    required this.name,
    this.gpsLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'districtId': districtId,
      'region': region,
      'name': name,
      'gpsLocation': gpsLocation?.toMap(),
    };
  }

  factory District.fromMap(Map<String, dynamic> map) {
    return District(
      districtId: map['districtId'],
      region: map['region'],
      name: map['name'],
      gpsLocation: GpsLocation.fromMap(map['gpsLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) =>
      District.fromMap(json.decode(source));
}

class County {
  final int districtId;
  final int countyId;
  final String name;
  final GpsLocation? gpsLocation;

  County({
    required this.districtId,
    required this.countyId,
    required this.name,
    this.gpsLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'districtId': districtId,
      'countyId': countyId,
      'name': name,
      'gpsLocation': gpsLocation?.toMap(),
    };
  }

  factory County.fromMap(Map<String, dynamic> map) {
    return County(
      districtId: map['districtId'],
      countyId: map['countyId'],
      name: map['name'],
      gpsLocation: GpsLocation.fromMap(map['gpsLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory County.fromJson(String source) => County.fromMap(json.decode(source));
}

class UserDataState {
  final String name;
  final String citizenCardNumber;
  final String email;
  final String phone;
  bool disclaimerShown;

  UserDataState({
    required this.name,
    required this.citizenCardNumber,
    required this.email,
    required this.phone,
    this.disclaimerShown = false,
  });
}

typedef IrnTables = Iterable<IrnTable>;

extension IrnTablesExtensoins on IrnTables {
  bool c<T>(T v1, T? v2) => v2 == null || v1 == v2;

  IrnTables clone() {
    return List<IrnTable>.from(this);
  }

  IrnTables filterBy(IrnTableSelection ts) {
    return where((t) =>
        c(t.serviceId, ts.serviceId) &&
        c(t.districtId, ts.districtId) &&
        c(t.countyId, ts.countyId) &&
        c(t.placeName, ts.placeName) &&
        c(t.date, ts.date));
  }
}

class IrnTable {
  final int countyId;
  final DateTime date;
  final int districtId;
  final String placeName;
  final String region;
  final int serviceId;
  final String tableNumber;
  final List<String> timeSlots;
  final GpsLocation? gpsLocation;
  IrnTable({
    required this.countyId,
    required this.date,
    required this.districtId,
    required this.placeName,
    required this.region,
    required this.serviceId,
    required this.tableNumber,
    required this.timeSlots,
    this.gpsLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'countyId': countyId,
      'date': date.toIso8601String().substring(0, 10),
      'districtId': districtId,
      'placeName': placeName,
      'region': region,
      'serviceId': serviceId,
      'tableNumber': tableNumber,
      'timeSlots': timeSlots,
      'gpsLocation': gpsLocation?.toMap(),
    };
  }

  factory IrnTable.fromMap(Map<String, dynamic> map) {
    return IrnTable(
      countyId: map['countyId'],
      date: DateTime.parse(map['date']),
      districtId: map['districtId'],
      placeName: map['placeName'],
      region: map['region'],
      serviceId: map['serviceId'],
      tableNumber: map['tableNumber'],
      timeSlots: List<String>.from(map['timeSlots']),
      gpsLocation: GpsLocation.fromMap(map['gpsLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IrnTable.fromJson(String source) =>
      IrnTable.fromMap(json.decode(source));
}

class IrnTableSelection {
  final int serviceId;
  final int countyId;
  final int districtId;
  final DateTime date;
  final String placeName;
  final String timeSlot;
  final String tableNumber;

  IrnTableSelection({
    required this.serviceId,
    required this.countyId,
    required this.districtId,
    required this.date,
    required this.placeName,
    this.timeSlot = "",
    this.tableNumber = "",
  });

  IrnTableSelection copyWith({
    int? serviceId,
    int? countyId,
    int? districtId,
    DateTime? date,
    String? placeName,
    String? timeSlot,
    String? tableNumber,
  }) {
    return IrnTableSelection(
      serviceId: serviceId ?? this.serviceId,
      countyId: countyId ?? this.countyId,
      districtId: districtId ?? this.districtId,
      date: date ?? this.date,
      placeName: placeName ?? this.placeName,
      timeSlot: timeSlot ?? this.timeSlot,
      tableNumber: tableNumber ?? this.tableNumber,
    );
  }
}

typedef IrnPlaces = List<IrnPlace>;

class IrnPlace {
  final String address;
  final int countyId;
  final int districtId;
  final String name;
  final String phone;
  final String postalCode;
  final GpsLocation? gpsLocation;

  IrnPlace({
    required this.address,
    required this.countyId,
    required this.districtId,
    required this.name,
    required this.phone,
    required this.postalCode,
    this.gpsLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'countyId': countyId,
      'districtId': districtId,
      'name': name,
      'phone': phone,
      'postalCode': postalCode,
      'gpsLocation': gpsLocation?.toMap(),
    };
  }

  factory IrnPlace.fromMap(Map<String, dynamic> map) {
    return IrnPlace(
      address: map['address'],
      countyId: map['countyId'],
      districtId: map['districtId'],
      name: map['name'],
      phone: map['phone'],
      postalCode: map['postalCode'],
      gpsLocation: GpsLocation.fromMap(map['gpsLocation']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IrnPlace.fromJson(String source) =>
      IrnPlace.fromMap(json.decode(source));
}

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

TimeOfDay timeOfDayFromSlot(String slot) {
  return TimeOfDay(
      hour: int.parse(slot.substring(0, 2)),
      minute: int.parse(slot.substring(3, 5)));
}

var nf = NumberFormat('00');

extension TimeOfDayExtension on TimeOfDay {
  String toSlot8() {
    return "${nf.format(hour)}:${nf.format(minute)}:00";
  }
}
