import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../data/irn_filter.dart';
import '../service_locator.dart';

const defaultFilter = const IrnFilter(
  serviceId: 1,
  region: "Continente",
);

class TablesFilter with ChangeNotifier {
  IrnFilter filter;

  TablesFilter({this.filter = defaultFilter});

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
