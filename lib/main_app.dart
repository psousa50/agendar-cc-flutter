import 'screens/Schedule/schedule_screen.dart';
import 'package:flutter/material.dart';

import 'app_config.dart';

class MainApp extends StatelessWidget {
  final AppConfig config;

  const MainApp(this.config);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: ScheduleScreen()),
      ),
    );
  }
}
