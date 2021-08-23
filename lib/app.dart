import 'package:flutter/material.dart';

import 'core/app_config.dart';
import 'core/app_providers.dart';
import 'features/home/presentation/pages/home.dart';

class App extends StatelessWidget {
  final AppConfig config;

  const App(this.config);

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(home: HomePage()),
    );
  }
}
