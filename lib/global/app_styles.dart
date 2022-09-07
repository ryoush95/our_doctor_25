import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FW { bold, semi_bold, medium, regular }
class AppTextStyle {

  static TextStyle PD(Color color, double size, {FW? weight = FW.bold, double height = 1, bool underline = false, bool ellipsis = false}) {
    return TextStyle(
        fontFamily: 'Pretendard',
        fontWeight: weight == FW.bold? FontWeight.bold: weight == FW.semi_bold? FontWeight.w600: weight == FW.medium? FontWeight.w500: FontWeight.normal,
        fontSize: size,
        height: height,
        color: color,
        overflow: ellipsis ? TextOverflow.ellipsis : TextOverflow.visible,
        decoration: underline? TextDecoration.underline: TextDecoration.none
    );
  }
}

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    final int oldTextLength = oldValue.text.length;
    int selectionIndex = newValue.selection.end;
    int usedSubstringIndex = 0;
    final StringBuffer newText = StringBuffer();
    if (oldTextLength < newTextLength && newTextLength == 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + '-');
      // if (newValue.selection.end == 3) {
      //   selectionIndex += 2;
      // }
    }
    if (oldTextLength < newTextLength && newTextLength == 9) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 8) + '-');
      // if (newValue.selection.end == 8) {
      //   selectionIndex += 2;
      // }
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
