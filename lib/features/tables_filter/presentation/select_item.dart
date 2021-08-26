import 'package:agendar_cc_flutter/widgets/page_with_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../../../../core/data/extensions.dart';

class ItemForSelection {
  final String id;
  final String name;
  final String normalizedName;
  ItemForSelection(this.id, this.name) : normalizedName = name.normalize();
}

class SelectItemPage extends StatefulWidget {
  final List<ItemForSelection> items;
  final String? selectedItem;
  final void Function(ItemForSelection?) onItemSelected;

  const SelectItemPage({
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  _SelectItemPageState createState() => _SelectItemPageState();
}

class _SelectItemPageState extends State<SelectItemPage> {
  var searchText = "";

  void onSearchTextChanged(String text) {
    setState(() {
      searchText = text.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildSeparator(String s) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        color: Colors.grey.shade300,
        child: Text(
          s,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget buildItem(BuildContext context, ItemForSelection item) {
      return GestureDetector(
        onTap: () =>
            widget.onItemSelected(widget.selectedItem == item.id ? null : item),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (widget.selectedItem == item.id) Icon(Icons.check),
            ],
          ),
        ),
      );
    }

    var normalizedText = searchText.normalize();
    return PageWithAppBar(
      title: "Select",
      child: Container(
        child: Column(
          children: [
            SearchBox(onSearchTextChanged),
            Expanded(
              child: GroupedListView<ItemForSelection, String>(
                elements: widget.items
                    .where((i) => i.normalizedName.contains(normalizedText))
                    .toList(),
                groupBy: (e) => e.name[0],
                itemBuilder: buildItem,
                groupSeparatorBuilder: buildSeparator,
                itemComparator: (i1, i2) => i1.name.compareTo(i2.name),
                separator: Divider(
                  height: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchBox(this.onChanged);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.zero,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
          autofocus: true,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            prefixIconConstraints: BoxConstraints(),
            hintText: "Search",
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
