import 'package:flutter/material.dart';

extension WidgetPadding on Widget {
  Padding padding({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        bottom: bottom,
        top: top,
      ),
      child: this,
    );
  }

  Padding symmetricPadding({
    double vertical = 0.0,
    double horizontal = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
      child: this,
    );
  }

  Padding paddingAll({
    double padding = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }
}
