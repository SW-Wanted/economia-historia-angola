import 'package:flutter/widgets.dart';

class Responsive {
  const Responsive._();

  static double maxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 700) return 520;
    return width;
  }

  static bool compact(BuildContext context) => MediaQuery.sizeOf(context).width < 360;
}
