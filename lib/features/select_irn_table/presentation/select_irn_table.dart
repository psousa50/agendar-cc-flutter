import 'package:agendar_cc_flutter/features/select_irn_table/presentation/select_timeslot.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/data/extensions.dart';
import '../../../core/data/models.dart';
import '../../../core/service_locator.dart';
import '../../../widgets/page_with_app_bar.dart';
import '../../schedule_at_irn/presentation/schedule_at_irn.dart';
import '../widgets/table_card_view.dart';

class SelectIrnTable extends StatefulWidget {
  final IrnTables tables;
  final IrnTableSelection tableSelection;
  const SelectIrnTable({
    Key? key,
    required this.tables,
    required this.tableSelection,
  }) : super(key: key);

  @override
  _SelectIrnTableState createState() => _SelectIrnTableState();
}

class _SelectIrnTableState extends State<SelectIrnTable> {
  late TimeOfDay timeSlot;
  late Set<String> distinctTimeSlots;

  @override
  void initState() {
    var sortedTimeSlots = widget.tables.first.timeSlots..sort();
    timeSlot = timeOfDayFromSlot(sortedTimeSlots.first);
    distinctTimeSlots = widget.tables
        .map((t) => t.timeSlots.map((ts) => ts.substring(0, 5)))
        .expand((t) => t)
        .toSet();
    super.initState();
  }

  IrnTableSelectionData from(IrnTableSelection ts, TimeOfDay timeSlot) {
    var r = ServiceLocator.referenceData;
    var place = r.irnPlace(ts.placeName);
    return IrnTableSelectionData(
      service: r.irnService(ts.serviceId).name,
      county: r.county(ts.countyId).name,
      place: ts.placeName,
      address: place.address,
      date: ts.date.toIso8601String().substring(0, 10),
      timeSlot: timeSlot.toSlotHHMM(),
    );
  }

  void onTimeSlotSelected(TimeOfDay time) {
    Navigator.of(context).pop();
    setState(() {
      timeSlot = time;
    });
  }

  void scheduleTable() {
    var tableNumber = widget.tables
        .where((t) => t.timeSlots.contains(timeSlot.toSlotHHMMSS()))
        .first
        .tableNumber;
    var fullTableSelection = widget.tableSelection.copyWith(
      timeSlot: timeSlot.toSlotHHMMSS(),
      tableNumber: tableNumber,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScheduleAtIrnPage(fullTableSelection),
      ),
    );
  }

  void selectTimeSlot() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SelectTimeSlotPage(
          timeSlots: distinctTimeSlots,
          onTimeSlotSelected: onTimeSlotSelected,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cardData = from(widget.tableSelection, timeSlot);
    return PageWithAppBar(
      title: "Seleccionar",
      child: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: TableCardView(cardData),
                ),
                ElevatedButton(
                  onPressed: scheduleTable,
                  child: Text("Agendar"),
                ),
                if (distinctTimeSlots.length > 1)
                  ElevatedButton(
                    onPressed: selectTimeSlot,
                    child: Text("Escolher outro horário"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
