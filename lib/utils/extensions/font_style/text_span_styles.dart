part of 'font_styles.dart';

extension TextSpanStyles on String {
  /// Returns a Text widget with regular font style.
  TextSpan textSpanRegular({
    Color? color,
    double? size,
  }) {
    return TextSpan(
      text: this,
      style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w400, color: color ?? AppColors.grey),
    );
  }

  /// Returns a Text widget with semi bold font style.
  TextSpan textSpanSemiBold({
    Color? color,
    double? size,
    TextDecoration? decoration,
  }) {
    return TextSpan(
      text: this,
      style: GoogleFonts.manrope(
        fontSize: size ?? 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.primaryColor,
        decoration: decoration ?? TextDecoration.none,
        decorationColor: AppColors.primaryColor, // Optional: Set the color of the underline
        decorationThickness: 2.0,
      ),
    );
  }
}
