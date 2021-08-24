import 'package:agendar_cc_flutter/features/home/presentation/widgets/filter_info.dart';
import 'package:agendar_cc_flutter/features/home/presentation/widgets/read_reference_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/models.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/tables_filter.dart';
import '../../../../widgets/page_with_app_bar.dart';
import '../widgets/tables_browser.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      title: "Mesas",
      child: ReadReferenceDataFuture(
        child: Consumer<TablesFilter>(
          builder: (_, tablesFilter, __) => HomePageView(tablesFilter),
        ),
      ),
    );
  }
}

class HomePageView extends StatelessWidget {
  final TablesFilter tablesFilter;
  const HomePageView(this.tablesFilter);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterInfo(tablesFilter),
        TablesFetcher(
          tablesFilter,
          (tables) => Expanded(
            child: TablesBrowser(tables),
          ),
        ),
      ],
    );
  }
}

typedef TablesFetcherBuilder = Widget Function(IrnTables);

class TablesFetcher extends StatelessWidget {
  final TablesFilter tablesFilter;
  final TablesFetcherBuilder builder;
  const TablesFetcher(this.tablesFilter, this.builder);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            ServiceLocator.irnTablesFetcher.fetchIrnTables(tablesFilter.filter),
        builder: (BuildContext context, AsyncSnapshot<IrnTables> snapshot) {
          var tables = snapshot.data ?? [];
          return builder(tables);
        });
  }
}
