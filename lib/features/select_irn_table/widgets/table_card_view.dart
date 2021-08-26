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
    return Card(
      elevation: 5,
      shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.service,
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tableCard.county,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.place,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.address,
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tableCard.date,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
