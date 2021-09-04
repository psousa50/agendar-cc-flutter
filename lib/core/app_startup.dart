import 'service_locator.dart';

class AppStartup {
  Future<void> setInitialLocation() async {
    var location = await ServiceLocator.geoLocator.getLocation();
    if (location != null) {
      var districtId =
          ServiceLocator.referenceData.getCloserDistrictTo(location);
      ServiceLocator.tablesFilter.updateDistrictId(districtId);
    }
  }

  Future<void> initialize() async {
    await ServiceLocator.referenceData.fetchAll();
    await ServiceLocator.persistence.initialize();

    if (ServiceLocator.persistence.runningFirstTime) {
      await setInitialLocation();
      ServiceLocator.persistence.update(runningFirstTime: false);
    }

    ServiceLocator.tablesFilter.updateAll(ServiceLocator.persistence.filter);
  }
}
