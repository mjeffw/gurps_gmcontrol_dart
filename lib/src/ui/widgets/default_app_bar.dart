import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/ui/styles.dart';

AppBar defaultAppBarGet({
  String titleText,
  Color backgroundColor = Styles.navBarBackground,
  AppBar bar,
}) {
  var appbar = AppBar(
    title: Text(titleText.toUpperCase(), style: Styles.navBarTitle),
    backgroundColor: Styles.navBarBackground,
    centerTitle: Styles.navBarCenterTitle,
    elevation: Styles.navBarElevation,
    iconTheme: Styles.navBarIconTheme,
    actions: bar.actions,
    actionsIconTheme: bar.actionsIconTheme,
    automaticallyImplyLeading: bar.automaticallyImplyLeading,
    bottom: bar.bottom,
    bottomOpacity: bar.bottomOpacity,
    brightness: bar.brightness,
    flexibleSpace: bar.flexibleSpace,
    key: bar.key,
    leading: bar.leading,
    primary: bar.primary,
    shape: bar.shape,
    textTheme: bar.textTheme,
    titleSpacing: bar.titleSpacing,
    toolbarOpacity: bar.toolbarOpacity,
  );

  return appbar;
}
