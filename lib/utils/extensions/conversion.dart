/// A class containing methods for various conversions.
class Conversion {
  /// Masks the middle digits of a phone number with asterisks.
  ///
  /// [countryCode] - The country code of the phone number.
  /// [phoneNumber] - The phone number to mask.
  ///
  /// Returns the masked phone number with the country code.
  static String maskPhoneNumber(String countryCode, String phoneNumber) {
    // Mask the middle digits of the phone number
    String maskedNumber = phoneNumber.replaceRange(2, 8, '******');

    // Concatenate the country code and the masked number
    String maskedPhoneNumber = '$countryCode $maskedNumber';

    return maskedPhoneNumber;
  }

  /// Formats seconds into a string with leading zeros.
  ///
  /// [seconds] - The number of seconds to format.
  ///
  /// Returns the formatted time string in the format '00:SS'.
  static String formatSeconds(int seconds) {
    // Add leading zeros to the seconds and convert it to a string
    String formattedSeconds = seconds.toString().padLeft(2, '0');

    // Concatenate the formatted seconds with a colon
    return '00:$formattedSeconds';
  }
}
