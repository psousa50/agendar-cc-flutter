import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../core/data/irn_filter.dart';
import '../../../core/service_locator.dart';
import '../../../widgets/page_with_app_bar.dart';
import 'select_item_page.dart';

class TablesFilterPage extends StatefulWidget {
  final IrnFilter filter;
  final Function(IrnFilter) onFilterChanged;
  TablesFilterPage({required this.filter, required this.onFilterChanged});

  @override
  _TablesFilterPageState createState() => _TablesFilterPageState();
}

class _TablesFilterPageState extends State<TablesFilterPage> {
  late IrnFilter filter;
  var refData = ServiceLocator.referenceData;

  @override
  void initState() {
    filter = widget.filter;
    super.initState();
  }

  void onRegionSelected(ItemForSelection? item) {
    Navigator.of(context).pop();
    setState(() {
      filter = normalizeFilter(
        filter,
        region: item?.id,
        districtId: filter.districtId,
        countyId: filter.countyId,
      );
    });
  }

  void onDistrictSelected(ItemForSelection? item) {
    Navigator.of(context).pop();
    setState(() {
      filter = normalizeFilter(
        filter,
        region: filter.region,
        districtId: item == null ? null : int.parse(item.id),
        countyId: filter.countyId,
      );
    });
  }

  void onCountySelected(ItemForSelection? item) {
    Navigator.of(context).pop();
    setState(() {
      filter = normalizeFilter(
        filter,
        region: filter.region,
        districtId: filter.districtId,
        countyId: item == null ? null : int.parse(item.id),
      );
    });
  }

  void pickRegion() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectItemPage(
          items: ServiceLocator.referenceData
              .regions()
              .map((r) => ItemForSelection(
                    r.regionId,
                    r.name,
                  ))
              .toList(),
          selectedItem: filter.region,
          onItemSelected: onRegionSelected),
    ));
  }

  void pickDistrict() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectItemPage(
          items: ServiceLocator.referenceData
              .filterDistricts(region: filter.region)
              .map((d) => ItemForSelection(
                    d.districtId.toString(),
                    d.name,
                  ))
              .toList(),
          selectedItem: filter.districtId.toString(),
          onItemSelected: onDistrictSelected),
    ));
  }

  void pickCounty() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectItemPage(
          items: ServiceLocator.referenceData
              .filterCounties(
                  region: filter.region, districtId: filter.districtId)
              .map((c) => ItemForSelection(
                    c.countyId.toString(),
                    c.name,
                  ))
              .toList(),
          selectedItem: filter.countyId.toString(),
          onItemSelected: onCountySelected),
    ));
  }

  void onApplyFilter() {
    Navigator.of(context).pop();
    ServiceLocator.tablesFilter.update(filter);
  }

  void clearAll() {
    setState(() {
      filter = normalizeFilter(filter,
          region: null, districtId: null, countyId: null);
    });
  }

  void useCurrentLocation() async {
    var districtId =
        await ServiceLocator.appStartUp.getCloserDistrictToCurrentLocation();
    if (districtId != null) {
      setState(() {
        filter = normalizeFilter(
          filter,
          region: filter.region,
          districtId: districtId,
          countyId: filter.countyId,
        );
      });
    }
  }

  void updateService(int serviceId) {
    setState(() {
      filter = filter.copyWith(
        serviceId: serviceId,
      );
    });
  }

  Widget buildServiceButton(int serviceId, String title) {
    var currentServiceId = filter.serviceId;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: OutlinedButton(
          onPressed: () => updateService(serviceId),
          child: Text(title),
          style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).canvasColor,
              primary: currentServiceId == serviceId
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).disabledColor),
        ),
      ),
    );
  }

  Widget buildService(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tipo de Serviço", style: Theme.of(context).textTheme.subtitle1),
        Row(
          children: [
            buildServiceButton(1, "Renovar CC"),
            buildServiceButton(2, "Levantar CC")
          ],
        ),
        Row(
          children: [
            buildServiceButton(3, "Renovar Passaporte"),
            buildServiceButton(4, "Levantar Passaporte")
          ],
        )
      ],
    );
  }

  Widget buildLocation(BuildContext context) {
    var region = filter.region;
    var districtId = filter.districtId;
    var countyId = filter.countyId;
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: Text(
              "Localização",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: useCurrentLocation,
              icon: Icon(Icons.location_searching),
              color: Theme.of(context).accentColor,
            ),
          )
        ]),
        Card(
          child: Column(
            children: [
              SectionItem(
                "Região",
                region,
                "Todas as Regiões",
                pickRegion,
              ),
              SectionItem(
                  "Distrito",
                  districtId == null ? null : refData.district(districtId).name,
                  "Todos os Distritos",
                  pickDistrict),
              SectionItem(
                  "Concelho",
                  countyId == null ? null : refData.county(countyId).name,
                  "Todos os Concelhos",
                  pickCounty),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      title: "Filtros",
      closeButton: true,
      actions: [
        IconButton(
          onPressed: clearAll,
          icon: Icon(Icons.clear_all),
        ),
        IconButton(
          onPressed: onApplyFilter,
          icon: Icon(Icons.done),
        ),
      ],
      child: Container(
        color: Theme.of(context).dividerColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            buildService(context),
            buildLocation(context),
          ],
        ),
      ),
    );
  }
}

class SectionItem extends StatelessWidget {
  final String title;
  final String? value;
  final String noValueText;
  final Function filterPicker;

  const SectionItem(
    this.title,
    this.value,
    this.noValueText,
    this.filterPicker,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => filterPicker(),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            child: Text(
              value ?? noValueText,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontStyle: value == null ? FontStyle.italic : null,
                  ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Icon(
              Icons.navigate_next,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
