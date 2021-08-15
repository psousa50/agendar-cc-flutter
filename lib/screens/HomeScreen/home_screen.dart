import 'package:flutter/material.dart';

import '../../service_locator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          height: 50,
          color: Colors.yellow,
        ),
        Expanded(
          child: Results(),
        )
      ],
    ));
  }
}

class Results extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ServiceLocator.referenceData.fetchAll(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          default:
            if (snapshot.hasError) {
              return Container(child: Text(snapshot.error.toString()));
            } else {
              return Container(child: Text("RESULTS"));
            }
        }
      },
    );
  }
}
