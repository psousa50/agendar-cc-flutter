class GpsLocation {
  final double latitude;
  final double longitude;
  GpsLocation({
    required this.latitude,
    required this.longitude,
  });
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

class IrnTableResult {
  final int serviceId;
  final int countyId;
  final int districtId;
  final DateTime date;
  final String placeName;
  final String timeSlot;
  final String tableNumber;

  IrnTableResult({
    required this.serviceId,
    required this.countyId,
    required this.districtId,
    required this.date,
    required this.placeName,
    required this.timeSlot,
    required this.tableNumber,
  });
}

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
}
