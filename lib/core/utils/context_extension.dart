import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  double dynamicHeight(double value) => height * value;
  double dynamicWidth(double value) => width * value;

  double get extraLowTextSize => height * 0.012;
  double get lowTextSize => height * 0.015;
  double get normalTextSize => height * 0.018;
  double get highTextSize => height * 0.022;
  double get extraHighTextSize => height * 0.025;

  double get extraLowPadding => height * 0.005;
  double get lowPadding => height * 0.01;
  double get normalPadding => height * 0.015;
  double get highPadding => height * 0.02;
  double get extraHighPadding => height * 0.025;

  double get extraLowRadius => height * 0.01;
  double get lowRadius => height * 0.015;
  double get normalRadius => height * 0.02;
  double get highRadius => height * 0.025;
  double get extraHighRadius => height * 0.035;

  double get extraLowIconSize => height * 0.015;
  double get lowIconSize => height * 0.02;
  double get normalIconSize => height * 0.025;
  double get highIconSize => height * 0.033;
  double get extraHighIconSize => height * 0.04;

  double get appBarHeight => height * 0.1;
}
