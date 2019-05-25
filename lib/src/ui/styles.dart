import 'package:flutter/material.dart';

Color _hexToColor(String code) =>
    Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);

class Styles {
  static const _textSizeDefault = 16.0;
  static const _textColorDefault = Colors.grey; //_hexToColor('666666');
  static const _fontWeightNormal = FontWeight.w400;

  static const _defaultTextStyle = TextStyle(
      fontWeight: _fontWeightNormal,
      fontSize: _textSizeDefault,
      color: _textColorDefault);

  static const _fontAwesomeDefaultStyle = TextStyle(
    fontFamily: 'FontAwesome Solid',
    fontWeight: _fontWeightNormal,
    fontSize: _textSizeDefault,
    color: _textColorDefault,
  );

  static final _navBarTitle = _defaultTextStyle.apply(
      fontSizeFactor: 1.5, fontWeightDelta: 2, color: _hexToColor('cccccc'));
  static final _nameTextStyle = _defaultTextStyle.apply(fontSizeFactor: 1.25);
  static const _labelStyle = _defaultTextStyle;
  static final _attributeStyle = _defaultTextStyle.apply(fontWeightDelta: 2);
  static final _oddRowBackground = Colors.grey.shade100;
  static const _evenRowBackground = Colors.white;
  static const _selectedRowBackground = Colors.amberAccent;
  static const _minimumWidthWidescreen = 600;

  static const navBarBackground = Colors.black;
  static const navBarCenterTitle = false;
  static const navBarElevation = 0.5;
  static const navBarIconTheme = IconThemeData(color: Colors.blue);

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

  static bool isWidescreen(BuildContext context) =>
      (MediaQuery.of(context).size.width > _minimumWidthWidescreen);
}
