import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/ui/styles.dart';

class DefaultAppBar extends AppBar {
  final String titleText;

  DefaultAppBar({@required this.titleText, List<Widget> actions})
      : super(
          title: Text(titleText.toUpperCase(), style: Styles.navBarTitle),
          actions: actions,
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.blue),
        );
}
