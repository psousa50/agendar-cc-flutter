import 'package:flutter/material.dart';

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
        toolbarHeight: 40,
        title: Text(title),
      ),
      body: child,
    );
  }
}
