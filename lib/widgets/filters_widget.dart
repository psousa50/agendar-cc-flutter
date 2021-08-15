import 'package:agendar_cc_flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models.dart';

typedef FilterPicker = Function();

class FiltersWidget extends StatefulWidget {
  final IrnFilter filter;
  FiltersWidget(this.filter);

  @override
  _FiltersWidgetState createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  var refData = ServiceLocator.referenceData;

  void pickRegion() {
    setState(() {
      filter.region = "Acores";
    });
  }

  void pickDistrict() {
    setState(() {
      filter.districtId = 4;
    });
  }

  IrnFilter get filter => widget.filter;

  @override
  Widget build(BuildContext context) {
    var region = filter.region;
    var districtId = filter.districtId;
    var countyId = filter.countyId;
    var placeName = filter.placeName;
    return Container(
      child: Column(
        children: [
          Section("Região", region ?? "Todas", refData.regions(), pickRegion),
          Section(
              "Distrito",
              districtId == null ? "Todos" : refData.district(districtId).name,
              region == null
                  ? refData.districts()
                  : refData.districtByRegion(region),
              pickDistrict),
          Section(
              "Concelho",
              countyId == null ? "Todos" : refData.county(countyId).name,
              districtId == null
                  ? refData.counties()
                  : refData.countyByDistrictId(districtId),
              pickDistrict),
          Section(
              "Local",
              placeName == null ? "Todos" : refData.irnPlace(placeName).name,
              countyId == null
                  ? refData.irnPlaces()
                  : refData.irnPlacesByCountyId(countyId),
              pickDistrict),
        ],
      ),
    );
  }
}

class Section<T> extends StatelessWidget {
  final String title;
  final String value;
  final Iterable<T> items;
  final FilterPicker filterPicker;

  const Section(
    this.title,
    this.value,
    this.items,
    this.filterPicker,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(title),
            ],
          ),
          GestureDetector(
            onTap: () => filterPicker(),
            child: Row(
              children: [
                Expanded(child: Text(value)),
                Icon(Icons.navigate_next),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
