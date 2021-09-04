import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/data/irn_filter.dart';
import '../../../../core/data/models.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/tables_filter.dart';
import '../../../../widgets/page_transitions.dart';
import '../../../../widgets/page_with_app_bar.dart';
import '../../../tables_filter/presentation/tables_filter_page.dart';
import '../widgets/app_startup_builder.dart';
import '../widgets/filter_info.dart';
import '../widgets/tables_browser.dart';

class HomePage extends StatelessWidget {
  void onFilterChanged(IrnFilter filter) {
    ServiceLocator.tablesFilter.update(filter);
  }

  void filter(BuildContext context) {
    Navigator.of(context).push(SlideBottomTopTransition(
      child: TablesFilterPage(
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
          onPressed: () => filter(context),
          icon: Icon(Icons.filter_list),
        )
      ],
      child: AppStartupBuilder(
        child: Consumer<TablesFilter>(
          builder: (_, tablesFilter, __) {
            return HomePageView(tablesFilter);
          },
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
        Expanded(child: TablesFetcher(tablesFilter)),
      ],
    );
  }
}

class TablesFetcher extends StatelessWidget {
  final TablesFilter tablesFilter;
  const TablesFetcher(this.tablesFilter);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            ServiceLocator.irnTablesFetcher.fetchIrnTables(tablesFilter.filter),
        builder: (BuildContext context, AsyncSnapshot<IrnTables> snapshot) {
          var tables = snapshot.data ?? [];
          return TablesBrowser(tables);
        });
  }
}
