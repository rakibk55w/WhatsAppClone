import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobileScreenLayout,
    required this.tabletScreenLayout,
  });

  final Widget mobileScreenLayout;
  final Widget tabletScreenLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return tabletScreenLayout;
        }
        return mobileScreenLayout;
      },
    );
  }
}
