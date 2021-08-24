import 'package:flutter/material.dart';

import '../../../../core/tables_filter.dart';

class FilterInfo extends StatelessWidget {
  final TablesFilter tablesFilter;
  const FilterInfo(this.tablesFilter);

  Widget buildInfoRow(String text, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(text, style: textStyle)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildInfoRow(
            tablesFilter.serviceDescription(),
            TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        buildInfoRow(
            tablesFilter.locationDescription(),
            TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ],
    );
  }
}
