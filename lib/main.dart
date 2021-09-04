import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/services/app_config.dart';
import 'core/service_locator.dart';

AppConfig getConfig() {
  var configProd = AppConfig(schema: 'https', host: 'agendar-cc.herokuapp.com');
  var configDev = AppConfig(
      schema: 'http',
      host: Platform.isIOS ? 'localhost' : '10.0.2.2',
      port: 3000);

  var config = kReleaseMode ? configProd : configDev;

  return config;
}

void initializeApp(AppConfig config) {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.setup(config);
}

void main() {
  var config = getConfig();
  initializeApp(config);
  runApp(App(config));
}
