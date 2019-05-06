import 'package:flutter/material.dart';

Color _hexToColor(String code) =>
    Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);

class Styles {
  static final _textSizeDefault = 16.0;
  static final _textColorDefault = _hexToColor('666666');
  static final _fontWeightNormal = FontWeight.w400;

  static final _defaultTextStyle = TextStyle(
      fontWeight: _fontWeightNormal,
      fontSize: _textSizeDefault,
      color: _textColorDefault);

  static final _fontAwesomeDefaultStyle = TextStyle(
    fontFamily: 'FontAwesome Solid',
    fontWeight: _fontWeightNormal,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final _navBarTitle = _defaultTextStyle.apply(
      fontSizeFactor: 1.5, fontWeightDelta: 2, color: _hexToColor('cccccc'));
  static final _nameTextStyle = _defaultTextStyle.apply(fontSizeFactor: 1.25);
  static final _labelStyle = _defaultTextStyle;
  static final _attributeStyle = _defaultTextStyle.apply(fontWeightDelta: 2);
  static final _oddRowBackground = Colors.grey.shade100;
  static final _evenRowBackground = Colors.white;
  static final _selectedRowBackground = Colors.amberAccent;

  static TextStyle get navBarTitle => _navBarTitle;
  static TextStyle get nameTextStyle => _nameTextStyle;
  static TextStyle get labelStyle => _labelStyle;
  static TextStyle get attributeStyle => _attributeStyle;

  static TextStyle get solidIconStyle => _fontAwesomeDefaultStyle;

  static Color listBackground(isOdd) =>
      isOdd ? _oddRowBackground : _evenRowBackground;

  static Color listRowBackground(bool e, int index) =>
      e ? _selectedRowBackground : Styles.listBackground(_isOdd(index));

  static bool _isOdd(int index) => (index % 2 != 0);
}
