import '../service_locator.dart';

class AppServices {
  Future<void> initialize() async {
    await ServiceLocator.referenceData.fetchAll();
    await ServiceLocator.persistence.initialize();

    if (ServiceLocator.persistence.runningFirstTime) {
      await useCurrentLocation();
      ServiceLocator.persistence.update(runningFirstTime: false);
    }

    ServiceLocator.tablesFilter.update(ServiceLocator.persistence.filter);
  }

  Future<int?> getCloserDistrictToCurrentLocation() async {
    var location = await ServiceLocator.geoLocator.getLocation();
    return location != null
        ? ServiceLocator.referenceData.getCloserDistrictTo(location).districtId
        : null;
  }

  Future<void> useCurrentLocation() async {
    var districtId = await getCloserDistrictToCurrentLocation();
    if (districtId != null) {
      ServiceLocator.tablesFilter.updateDistrictId(districtId);
    }
  }
}
