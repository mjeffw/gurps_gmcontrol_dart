import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/utils/enumeration.dart';
import 'package:gurps_gmcontrol_dart/widgets/enumerated_text_widget.dart';

class EnumeratedTextMenu extends StatelessWidget {
  final Enumeration enumeration;
  final PopupMenuItemSelected<String> onSelected;

  EnumeratedTextMenu({this.enumeration, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        onSelected: onSelected,
        child: EnumeratedTextWidget(enumeration),
        itemBuilder: (BuildContext context) {
          var list = <PopupMenuEntry<String>>[];
          enumeration.allValues.forEach((f) {
            list.add(PopupMenuItem(
              value: f,
              child: Text(f),
            ));
          });
          return list;
        });
  }
}
