import 'package:flutter/material.dart';

import '../../../../core/service_locator.dart';

class AppStartupBuilder extends StatelessWidget {
  final Widget child;
  const AppStartupBuilder({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ServiceLocator.appStartUp.initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                child: CircularProgressIndicator(),
                alignment: Alignment.center,
              );
            default:
              if (snapshot.hasError) {
                return Container(
                  child: Text(
                    snapshot.error.toString(),
                  ),
                );
              } else {
                return child;
              }
          }
        });
  }
}
