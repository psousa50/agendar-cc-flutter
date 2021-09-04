import 'package:get_it/get_it.dart';

import '../api/irn_tables_fetcher.dart';
import '../api/reference_data.dart';
import 'services/app_config.dart';
import 'services/app_persistence.dart';
import 'services/app_services.dart';
import 'services/geo_locator_service.dart';
import 'services/tables_filter.dart';

class ServiceLocator {
  static final _getIt = GetIt.I;

  static ReferenceData get referenceData => _getIt<ReferenceData>();
  static IrnTablesFetcher get irnTablesFetcher => _getIt<IrnTablesFetcher>();
  static TablesFilter get tablesFilter => _getIt<TablesFilter>();
  static GeoLocatorService get geoLocator => _getIt<GeoLocatorService>();
  static AppPersistence get persistence => _getIt<AppPersistence>();
  static AppServices get appStartUp => _getIt<AppServices>();

  static void setup(AppConfig config) {
    _getIt.registerSingleton<ReferenceData>(ReferenceData(config));
    _getIt.registerSingleton<IrnTablesFetcher>(IrnTablesFetcher(config));
    _getIt.registerSingleton<TablesFilter>(TablesFilter());
    _getIt.registerSingleton<GeoLocatorService>(GeoLocatorService());
    _getIt.registerSingleton<AppPersistence>(AppPersistence());
    _getIt.registerSingleton<AppServices>(AppServices());
  }
}
