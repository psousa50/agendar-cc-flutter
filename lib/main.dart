import 'dart:io';

import 'core/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'app.dart';

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
  ServiceLocator.setup(config);
}

void main() {
  var config = getConfig();
  initializeApp(config);
  runApp(App(config));
}
