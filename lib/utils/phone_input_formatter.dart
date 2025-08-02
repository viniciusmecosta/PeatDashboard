import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length > 11) {
      return oldValue;
    }

    final int length = digitsOnly.length;
    final StringBuffer buffer = StringBuffer();

    if (length > 0) {
      buffer.write('(${digitsOnly.substring(0, length < 2 ? length : 2)}');
    }
    if (length > 2) {
      buffer.write(') ${digitsOnly.substring(2, length < 3 ? length : 3)}');
    }
    if (length > 3) {
      buffer.write(' ${digitsOnly.substring(3, length < 7 ? length : 7)}');
    }
    if (length > 7) {
      buffer.write('-${digitsOnly.substring(7, length < 11 ? length : 11)}');
    }

    String newText = buffer.toString();
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
