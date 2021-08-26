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
    var countyId = filter.countyId;
    var districtId = filter.districtId;
    return countyId == null
        ? districtId == null
            ? "Distrito: (Todos)"
            : "Distrito: ${ref.district(districtId).name}"
        : "Concelho: ${ref.county(countyId).name}";
  }

  String locationDescription() {
    return "${filter.region} - ${countyDescription()}";
  }

  String serviceDescription() {
    var ref = ServiceLocator.referenceData;
    return ref.irnService(filter.serviceId!).name;
  }

  void updateAll(
    IrnFilter other,
  ) {
    filter = filter.copyWith(
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

    notifyListeners();
  }
}
