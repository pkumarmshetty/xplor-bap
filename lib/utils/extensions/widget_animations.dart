import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension ListWidgetAnimations on List<Widget> {
  AnimateList<Widget> fadeInAnimation({Duration? scaleDelay}) {
    return animate().fadeIn(duration: 500.ms);
  }
}
