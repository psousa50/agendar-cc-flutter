import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class ItemForSelection {
  final String id;
  final String name;
  ItemForSelection(this.id, this.name);
}

class SelectItemWidget extends StatefulWidget {
  final List<ItemForSelection> items;
  final void Function(ItemForSelection) itemSelected;

  const SelectItemWidget({
    required this.items,
    required this.itemSelected,
  });

  @override
  _SelectItemWidgetState createState() => _SelectItemWidgetState();
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
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
        child: Text(
          s,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        color: Colors.grey[800],
      );
    }

    Widget buildItem(BuildContext context, ItemForSelection item) {
      return GestureDetector(
        onTap: () => widget.itemSelected(item),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            item.name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Colors.black,
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SearchBox(onSearchTextChanged),
          Expanded(
            child: GroupedListView<ItemForSelection, String>(
              elements: widget.items
                  .where((i) => i.name.toLowerCase().contains(searchText))
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
      color: Colors.grey[900],
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
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
