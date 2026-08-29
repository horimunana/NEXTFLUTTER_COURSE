import 'package:flutter/material.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, LayoutBreakpoint breakpoint)
      builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = _breakpointFor(constraints.maxWidth);
        return builder(context, breakpoint);
      },
    );
  }
}

enum LayoutBreakpoint {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == LayoutBreakpoint.mobile;
  bool get isTablet => this == LayoutBreakpoint.tablet;
  bool get isDesktop => this == LayoutBreakpoint.desktop;
}

LayoutBreakpoint _breakpointFor(double width) {
  if (width < 600) return LayoutBreakpoint.mobile;
  if (width < 1000) return LayoutBreakpoint.tablet;
  return LayoutBreakpoint.desktop;
}

int gridColumnsFor(LayoutBreakpoint breakpoint) {
  switch (breakpoint) {
    case LayoutBreakpoint.mobile:
      return 2;
    case LayoutBreakpoint.tablet:
      return 3;
    case LayoutBreakpoint.desktop:
      return 4;
  }
}
