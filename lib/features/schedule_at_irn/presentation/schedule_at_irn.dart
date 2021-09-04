import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/data/models.dart';
import '../../../core/service_locator.dart';
import '../../../widgets/page_with_app_bar.dart';
import '../data/javascript_code.dart';

class ScheduleAtIrnPage extends StatelessWidget {
  final IrnTableSelection tableSelection;
  const ScheduleAtIrnPage(this.tableSelection);

  @override
  Widget build(BuildContext context) {
    var place = ServiceLocator.referenceData.irnPlace(tableSelection.placeName);

    var user = ServiceLocator.persistence.userData;

    return PageWithAppBar(
        child: InAppWebView(
          onLoadStop: (controller, url) async {
            await controller.evaluateJavascript(
                source: JavaScriptCode.javascript(tableSelection, place, user));
          },
          initialUrlRequest: URLRequest(
              url: Uri.parse("https://agendamento.irn.mj.pt/steps/step1.php")),
        ),
        title: "Agendamento");
  }
}
