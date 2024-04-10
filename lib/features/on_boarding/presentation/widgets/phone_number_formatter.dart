import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// Implement logic to format phone number as desired
    final text = newValue.text.replaceAll(RegExp(r'\s+'), '');

    /// Remove spaces
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (text.length == 10) {
        if (i == 3 || i == 6) {
          buffer.write(' ');
        }
      } else {
        if (i == 3 || i == 6 || i == 9 || i == 12) {
          buffer.write(' ');
        }
      }

      /// Add space after third and sixth character
      buffer.write(text[i]);
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
