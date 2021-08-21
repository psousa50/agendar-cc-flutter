import '../../../core/data/models.dart';
import '../data/javascript_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var table = IrnTableResult(
      countyId: 18,
      districtId: 2,
      date: DateTime(2021, 09, 20),
      placeName: "Conservatória do Registo Civil de Aveiro",
      serviceId: 1,
      tableNumber: "4",
      timeSlot: "11:15:00",
    );

    var place = IrnPlace(
      address: "Rua D. António José Cordeiro, Nº 26/28",
      countyId: 18,
      districtId: 2,
      name: "Conservatória do Registo Civil de Aveiro",
      phone: "234404450",
      postalCode: "3800-003",
    );

    var user = UserDataState(
      citizenCardNumber: "7343623",
      email: "pedronsousa@gmail.com",
      name: "Pedro Sousa",
      phone: "961377576",
    );

    return InAppWebView(
      onLoadStop: (controller, url) async {
        await controller.evaluateJavascript(
            source: JavaScriptCode.javascript(table, place, user));
      },
      initialUrlRequest: URLRequest(
          url: Uri.parse("https://agendamento.irn.mj.pt/steps/step1.php")),
    );
  }
}
