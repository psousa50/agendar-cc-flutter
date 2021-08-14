import 'screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';
import 'app_providers.dart';

class MainApp extends StatelessWidget {
  final AppConfig config;

  const MainApp(this.config);

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      config: config,
      child: MaterialApp(
        home: Scaffold(
          body: SafeArea(child: HomeScreen()),
        ),
      ),
    );
  }
}
