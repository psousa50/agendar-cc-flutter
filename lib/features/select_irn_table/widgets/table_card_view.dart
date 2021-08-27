import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IrnTableSelectionData {
  final String service;
  final String county;
  final String place;
  final String address;
  final String date;
  const IrnTableSelectionData({
    this.service = "...",
    this.county = "...",
    this.place = "...",
    this.address = "...",
    this.date = "...",
  });
}

class TableCardView extends StatelessWidget {
  final IrnTableSelectionData tableCard;
  const TableCardView(this.tableCard);
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.service,
                style: textTheme.subtitle1,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tableCard.county,
                  style: textTheme.subtitle1,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.place,
                style: textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.address,
                style: textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.date,
                style: textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
