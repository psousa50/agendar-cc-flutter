import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';

typedef FilterPicker<T> = T Function(T value);

class FiltersWidget extends StatefulWidget {
  final IrnFilter filter;
  FiltersWidget(this.filter);

  @override
  _FiltersWidgetState createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  String pickRegion(String region) {
    return "Acores";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Section("Region", "Madeira", pickRegion)],
      ),
    );
  }
}

class Section<T> extends StatelessWidget {
  final String title;
  final String value;
  final FilterPicker<T> filterPicker;

  const Section(
    this.title,
    this.value,
    this.filterPicker,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(title),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text(value)),
              Icon(Icons.navigate_next),
            ],
          ),
        ],
      ),
    );
  }
}
