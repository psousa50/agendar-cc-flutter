import 'package:flutter/material.dart';

class PageWithAppBar extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  const PageWithAppBar({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: Text(title),
        actions: actions,
      ),
      body: child,
    );
  }
}

class SafePage extends StatelessWidget {
  final Widget child;
  const SafePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child,
      ),
    );
  }
}
