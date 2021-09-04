import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../service_locator.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  AppProviders({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ServiceLocator.tablesFilter)
      ],
      child: child,
    );
  }
}
