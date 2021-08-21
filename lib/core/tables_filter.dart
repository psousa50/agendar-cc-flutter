import 'package:agendar_cc_flutter/core/data/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TablesFilter with ChangeNotifier {
  IrnFilter filter = IrnFilter(serviceId: 1);

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
