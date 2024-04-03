import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension Space on num {
  SizedBox vSpace() {
    return SizedBox(
      height: w,
    );
  }

  SizedBox hSpace() {
    return SizedBox(
      width: w,
    );
  }
}
