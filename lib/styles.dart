import 'package:flutter/material.dart';

class Styles {
  static const _textSizeDefault = 16.0;
  static final Color _textColorDefault = _hexToColor('666666');

  static final navBarTitle = TextStyle(
    // fontFamily: _fontNameDefault,
    fontWeight: FontWeight.w600,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static TextStyle nameTextStyle(bool expanded) {
    return TextStyle(
        fontSize: 20.0, color: expanded ? Colors.deepOrange : Colors.black);
  }

  static TextStyle labelStyle() {
    return TextStyle(
        fontSize: _textSizeDefault,
        color: _textColorDefault,
        fontWeight: FontWeight.w400);
  }

  static TextStyle attributeStyle() {
    return TextStyle(
        fontSize: _textSizeDefault,
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w600);
  }

  static Color _hexToColor(String code) =>
      Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
}
