import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/styles.dart';

class DefaultAppBar extends AppBar {
  final String titleText;

  DefaultAppBar({@required this.titleText})
      : title = Text(titleText.toUpperCase(), style: Styles.navBarTitle);

  @override
  final Widget title;

  @override
  final Color backgroundColor = Colors.black;

  @override
  final bool centerTitle = true;

  @override
  final double elevation = 0.5;

  @override
  final IconThemeData iconTheme = IconThemeData(color: Colors.blue);
}
