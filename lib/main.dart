import 'service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';
import 'main_app.dart';

AppConfig getConfig() {
  var configProd = AppConfig(host: 'https://agendar-cc.herokuapp.com');
  // var configDev = AppConfig(
  //     host: Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2',
  //     port: 5678);

  var config = kReleaseMode ? configProd : configProd;

  return config;
}

void initializeApp(AppConfig config) {
  ServiceLocator.setup(config);
}

void main() {
  var config = getConfig();
  initializeApp(config);
  runApp(MainApp(config));
}
