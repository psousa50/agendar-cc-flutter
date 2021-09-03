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
    await setInitialLocation();
  }
}
