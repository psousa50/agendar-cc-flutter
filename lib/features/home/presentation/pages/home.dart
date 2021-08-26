import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/irn_filter.dart';
import '../../../../core/data/models.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/tables_filter.dart';
import '../../../../widgets/page_with_app_bar.dart';
import '../../../tables_filter/presentation/tables_filter_page.dart';
import '../widgets/filter_info.dart';
import '../widgets/read_reference_data.dart';
import '../widgets/tables_browser.dart';

class HomePage extends StatelessWidget {
  void onFilterChanged(IrnFilter filter) {
    ServiceLocator.tablesFilter.updateAll(filter);
  }

  void filter(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TablesFilterPage(
        filter: ServiceLocator.tablesFilter.filter,
        onFilterChanged: onFilterChanged,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return PageWithAppBar(
      title: "Mesas",
      actions: [
        IconButton(
            onPressed: () => filter(context), icon: Icon(Icons.filter_list))
      ],
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
