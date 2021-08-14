import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  final AppConfig config;

  AppProviders({
    required this.child,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppConfig>.value(value: config),
      ],
      child: child,
    );
  }
}
