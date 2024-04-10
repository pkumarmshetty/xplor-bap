part of 'font_styles.dart';

extension TitleStyles on String {
  /// Returns a Text widget with thin font style.
  Text titleThin({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w100, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with extra light font style.
  Text titleExtraLight({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w200, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with light font style.
  Text titleLight({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w300, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with regular font style.
  Text titleRegular({
    Color? color,
    double? size,
    TextAlign? align,
  }) {
    return Text(
      this,
      textAlign: align,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w400, color: color ?? AppColors.textColor,
      ),
    );
  }

  /// Returns a Text widget with medium font style.
  Text titleMedium({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w500, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with semi bold font style.
  Text titleSemiBold({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w600, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with bold font style.
  Text titleBold({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w700, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with extra bold font style.
  Text titleExtraBold({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w800, color: color ?? AppColors.textColor),
    );
  }

  /// Returns a Text widget with black font style.
  Text titleBlack({
    Color? color,
    double? size,
  }) {
    return Text(
      this,
      style: GoogleFonts.manrope(
          fontSize: size ?? 28.sp, fontWeight: FontWeight.w900, color: color ?? AppColors.textColor),
    );
  }
}
