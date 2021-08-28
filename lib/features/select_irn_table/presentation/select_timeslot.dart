import 'package:flutter/material.dart';

import '../../../widgets/page_with_app_bar.dart';
import '../widgets/timeslots_selector.dart';

class SelectTimeSlotPage extends StatelessWidget {
  final Set<String> timeSlots;
  final Function(TimeOfDay) onTimeSlotSelected;

  const SelectTimeSlotPage({
    required this.timeSlots,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      title: "Escolha de Horário",
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: TimeSlotsSelector(
          timeSlots: timeSlots,
          onTimeSlotSelected: onTimeSlotSelected,
        ),
      ),
    );
  }
}
