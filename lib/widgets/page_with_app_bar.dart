import 'package:flutter/material.dart';

class PageWithAppBar extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool closeButton;
  const PageWithAppBar({
    Key? key,
    required this.child,
    required this.title,
    this.actions,
    this.closeButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        automaticallyImplyLeading: !closeButton,
        leading: closeButton
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              )
            : null,
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
