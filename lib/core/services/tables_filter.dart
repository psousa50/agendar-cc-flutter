import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/extensions.dart';
import '../data/irn_filter.dart';
import '../service_locator.dart';

const defaultFilter = const IrnFilter(
  serviceId: 1,
  region: "Continente",
);

class TablesFilter with ChangeNotifier {
  IrnFilter filter;

  TablesFilter({this.filter = defaultFilter});

  String countyDescription() {
    var ref = ServiceLocator.referenceData;
    var region = filter.region;
    var countyId = filter.countyId;
    var county = countyId != null ? ref.county(countyId) : null;
    var districtId = filter.districtId ??
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

  String formatDate(DateTime date) {
    return date.toIso8601String().substring(0, 10);
  }

  String formatTime(TimeOfDay time) {
    return time.toSlotHHMM();
  }

  String dateRangeDescription() {
    var startDate = filter.startDate;
    var endDate = filter.endDate;
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
    var startTime = filter.startTime;
    var endTime = filter.endTime;
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
    return ref.irnService(filter.serviceId!).name;
  }

  void update(
    IrnFilter other,
  ) {
    filter = IrnFilter(
      serviceId: other.serviceId,
      region: other.region,
      districtId: other.districtId,
      countyId: other.countyId,
      placeName: other.placeName,
      startTime: other.startTime,
      endTime: other.endTime,
      startDate: other.startDate,
      endDate: other.endDate,
    );

    ServiceLocator.persistence.update(filter: filter);

    notifyListeners();
  }

  void updateWith(
    int? serviceId,
    String? region,
    int? districtId,
    int? countyId,
    String? placeName,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    update(
      filter.copyWith(
        serviceId: serviceId,
        region: region,
        districtId: districtId,
        countyId: countyId,
        placeName: placeName,
        startTime: startTime,
        endTime: endTime,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  void updateDistrictId(int districtId) {
    update(
      normalizeFilter(
        filter,
        districtId: districtId,
      ),
    );
  }
}
