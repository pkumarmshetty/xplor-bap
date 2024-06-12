part of 'font_styles.dart';

extension ButtonStyles on String {
  /// Returns a Text widget with thin font style.
  Text buttonTextThin({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w100));
  }

  /// Returns a Text widget with extra light font style.
  Text buttonTextExtraLight({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w200));
  }

  /// Returns a Text widget with light font style.
  Text buttonTextLight({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w300));
  }

  /// Returns a Text widget with regular font style.
  Text buttonTextRegular({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w400));
  }

  /// Returns a Text widget with medium font style.
  Text buttonTextMedium({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w500));
  }

  /// Returns a Text widget with semi bold font style.
  Text buttonTextSemiBold({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w600));
  }

  /// Returns a Text widget with bold font style.
  Text buttonTextBold({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w700, color: color),
    );
  }

  /// Returns a Text widget with extra bold font style.
  Text buttonTextExtraBold({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w800));
  }

  /// Returns a Text widget with black font style.
  Text buttonTextBlack({
    Color? color,
    double? size,
  }) {
    return Text(this, style: GoogleFonts.manrope(fontSize: size ?? 14.sp, fontWeight: FontWeight.w800));
  }
}
