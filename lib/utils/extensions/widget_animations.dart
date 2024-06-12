import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension ListWidgetAnimations on List<Widget> {
  AnimateList<Widget> fadeInAnimation({Duration? scaleDelay}) {
    return animate().fadeIn(duration: 500.ms);
  }
}

extension WidgetAnimations on Widget {
  Widget scaleAnimated() {
    return animate().fade(duration: 800.ms).scale(delay: 800.ms);
  }

  Widget scaleXAnimated() {
    return animate().fadeIn().scaleX();
  }

  Widget scaleYAnimated() {
    return animate().fadeIn().scaleY(delay: 600.ms);
  }

  Widget fadeInAnimated() {
    return animate().fadeIn(duration: 800.ms);
  }

  Widget fadeAnimation() {
    return animate().fade(duration: 800.ms);
  }
}
