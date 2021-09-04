import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'data/irn_filter.dart';
import 'service_locator.dart';

class TablesFilter with ChangeNotifier {
  IrnFilter filter = IrnFilter(
    serviceId: 1,
    region: "Continente",
  );

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

  String locationDescription() {
    return "${countyDescription()}";
  }

  String serviceDescription() {
    var ref = ServiceLocator.referenceData;
    return ref.irnService(filter.serviceId!).name;
  }

  void updateAll(
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

  void update(
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
    filter = filter.copyWith(
      serviceId: serviceId,
      region: region,
      districtId: districtId,
      countyId: countyId,
      placeName: placeName,
      startTime: startTime,
      endTime: endTime,
      startDate: startDate,
      endDate: endDate,
    );

    ServiceLocator.persistence.update(filter: filter);

    notifyListeners();
  }

  updateDistrictId(int districtId) {
    filter = normalizeFilter(filter, districtId: districtId);

    ServiceLocator.persistence.update(filter: filter);
  }
}
