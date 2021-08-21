import 'package:agendar_cc_flutter/api/irn_tables_fetcher.dart';

import '../api/reference_data.dart';
import 'app_config.dart';
import 'package:get_it/get_it.dart';

import 'tables_filter.dart';

class ServiceLocator {
  static final _getIt = GetIt.I;

  static ReferenceData get referenceData => _getIt<ReferenceData>();
  static IrnTablesFetcher get irnTablesFetcher => _getIt<IrnTablesFetcher>();
  static TablesFilter get tablesFilter => _getIt<TablesFilter>();

  static void setup(AppConfig config) {
    _getIt.registerSingleton<ReferenceData>(ReferenceData(config));
    _getIt.registerSingleton<IrnTablesFetcher>(IrnTablesFetcher(config));
    _getIt.registerSingleton<TablesFilter>(TablesFilter());
  }
}
