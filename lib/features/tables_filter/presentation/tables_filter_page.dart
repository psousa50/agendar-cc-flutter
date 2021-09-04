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

  void onServiceSelected(ItemForSelection? item) {
    Navigator.of(context).pop();
    setState(() {
      filter = filter.copyWith(
        serviceId: item == null ? null : int.parse(item.id),
      );
    });
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

  void pickService() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SelectItemPage(
          items: ServiceLocator.referenceData
              .irnServices()
              .map((s) => ItemForSelection(
                    s.serviceId.toString(),
                    s.name,
                  ))
              .toList(),
          selectedItem: filter.serviceId.toString(),
          onItemSelected: onServiceSelected),
    ));
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
        await ServiceLocator.appStartUp.getCLoserDistrictToCurrentLocation();
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

  @override
  Widget build(BuildContext context) {
    var serviceId = filter.serviceId;
    var region = filter.region;
    var districtId = filter.districtId;
    var countyId = filter.countyId;
    return PageWithAppBar(
      title: "Filtros",
      closeButton: true,
      actions: [
        IconButton(
          onPressed: useCurrentLocation,
          icon: Icon(Icons.location_searching),
        ),
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
        padding: EdgeInsets.all(8),
        color: Theme.of(context).dividerColor,
        child: Column(
          children: [
            Section(
              "Serviço",
              serviceId == null ? "Todos" : refData.irnService(serviceId).name,
              pickService,
            ),
            Section(
              "Região",
              region ?? "Todas",
              pickRegion,
            ),
            Section(
                "Distrito",
                districtId == null
                    ? "Todos"
                    : refData.district(districtId).name,
                pickDistrict),
            Section(
                "Concelho",
                countyId == null ? "Todos" : refData.county(countyId).name,
                pickCounty),
          ],
        ),
      ),
    );
  }
}

class Section<T> extends StatelessWidget {
  final String title;
  final String value;
  final Function filterPicker;

  const Section(
    this.title,
    this.value,
    this.filterPicker,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
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
                  value,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Icon(
                  Icons.navigate_next,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
