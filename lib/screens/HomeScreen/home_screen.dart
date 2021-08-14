import '../../models.dart';
import '../../widgets/filters_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var filter = IrnFilter();
    return FiltersWidget(filter);
  }
}
