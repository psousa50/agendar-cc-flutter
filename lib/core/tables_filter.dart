import 'package:agendar_cc_flutter/core/data/models.dart';
import 'package:agendar_cc_flutter/core/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TablesFilter with ChangeNotifier {
  IrnFilter filter = IrnFilter(
    serviceId: 1,
    region: "Continente",
    // districtId: 3,
    // countyId: 12,
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
