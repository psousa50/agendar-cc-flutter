import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/data/models.dart';
import '../../../core/service_locator.dart';
import '../../../widgets/page_with_app_bar.dart';
import '../../schedule_at_irn/presentation/schedule_at_irn.dart';
import '../widgets/table_card_view.dart';
import '../widgets/timeslots_selector.dart';

class SelectIrnTable extends StatelessWidget {
  final IrnTables tables;
  final IrnTableSelection tableSelection;
  const SelectIrnTable({
    Key? key,
    required this.tables,
    required this.tableSelection,
  }) : super(key: key);

  IrnTableSelectionData from(IrnTableSelection t) {
    var r = ServiceLocator.referenceData;
    return IrnTableSelectionData(
      service: r.irnService(t.serviceId).name,
      county: r.county(t.countyId).name,
      place: t.placeName,
      date: t.date.toIso8601String().substring(0, 10),
    );
  }

  void onTimeSlotSelected(BuildContext context, TimeOfDay time) {
    var timeSlot = time.toSlot8();
    var tableNumber =
        tables.where((t) => t.timeSlots.contains(timeSlot)).first.tableNumber;
    var fullTableSelection = tableSelection.copyWith(
      timeSlot: timeSlot,
      tableNumber: tableNumber,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ScheduleAtIrnPage(fullTableSelection)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cardData = from(tableSelection);
    return PageWithAppBar(
      title: "Seleccionar",
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TableCardView(cardData),
              ),
              Expanded(
                child: TimeSlotsSelector(
                  tables: tables.filterBy(tableSelection),
                  onTimeSlotSelected: (slot) =>
                      onTimeSlotSelected(context, slot),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
