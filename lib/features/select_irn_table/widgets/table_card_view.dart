import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../ui/themes.dart';

class IrnTableSelectionData {
  final String service;
  final String county;
  final String place;
  final String address;
  final String date;
  final String timeSlot;
  const IrnTableSelectionData({
    required this.service,
    required this.county,
    required this.place,
    required this.address,
    required this.date,
    required this.timeSlot,
  });
}

class TableCardView extends StatelessWidget {
  final IrnTableSelectionData tableCard;
  final Widget? child;

  const TableCardView({required this.tableCard, required this.child});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                tableCard.service,
                style: textTheme.subtitle1,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  tableCard.county,
                  style: textTheme.subtitle1!
                      .copyWith(color: AppColors.selectedTable),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                tableCard.place,
                style: textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                tableCard.address,
                style: textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                tableCard.date,
                style: textTheme.subtitle1!
                    .copyWith(color: AppColors.selectedTable),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                tableCard.timeSlot,
                style: textTheme.subtitle2,
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
