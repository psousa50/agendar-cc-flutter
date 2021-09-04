import 'ui/themes.dart';
import 'package:flutter/material.dart';

import 'core/services/app_config.dart';
import 'core/services/app_providers.dart';
import 'features/home/presentation/pages/home.dart';

class App extends StatelessWidget {
  final AppConfig config;

  const App(this.config);

  @override
  Widget build(BuildContext context) {
    var useDarkTheme = false;
    return AppProviders(
      child: MaterialApp(
        home: HomePage(),
        theme: useDarkTheme ? darkTheme : lightTheme,
      ),
    );
  }
}
