import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:time_range_selector/time_range_selector.dart';

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
        supportedLocales:
            TimeRangeSelectorLocalizations.delegate.supportedLocales,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          TimeRangeSelectorLocalizations.delegate,
        ],
      ),
    );
  }
}
