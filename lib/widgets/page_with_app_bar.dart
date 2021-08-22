import 'dart:io';

import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final Widget child;
  const MainPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
    );
  }
}

class PageWithAppBar extends StatelessWidget {
  final Widget child;
  final String title;
  const PageWithAppBar({
    Key? key,
    required this.child,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.of(context).canPop()
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back))
            : null,
        title: Text(title),
      ),
      body: child,
    );
  }
}
