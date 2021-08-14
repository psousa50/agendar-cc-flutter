import 'package:flutter/material.dart';

import '../../api/irnPlaces.dart';
import '../../widgets/select_item_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void itemSelected(ItemForSelection item) {
      print(item.id);
    }

    return SelectItemWidget(
      items: irnPlaces
          .map((e) => ItemForSelection(
                e.countyId.toString(),
                e.name,
              ))
          .toList(),
      itemSelected: itemSelected,
    );
  }
}
