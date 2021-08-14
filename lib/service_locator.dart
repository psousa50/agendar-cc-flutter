import 'api/reference_data.dart';
import 'app_config.dart';
import 'package:get_it/get_it.dart';

import 'areas_manager.dart';

class ServiceLocator {
  static final _getIt = GetIt.I;

  static ReferenceData get referenceData => _getIt<ReferenceData>();
  static AreasManager get areasManager => _getIt<AreasManager>();

  static void setup(AppConfig config) {
    _getIt.registerSingleton<ReferenceData>(ReferenceData(config));
    _getIt.registerSingleton<AreasManager>(AreasManager());
  }
}
