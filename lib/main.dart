import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';
import 'main_app.dart';

AppConfig getConfig() {
  var configProd = AppConfig(host: 'https://covid19-matrix-50.herokuapp.com');
  var configDev = AppConfig(
      host: Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2',
      port: 5678);

  var config = kReleaseMode ? configProd : configDev;

  return config;
}

void main() {
  var config = getConfig();
  runApp(MainApp(config));
}
