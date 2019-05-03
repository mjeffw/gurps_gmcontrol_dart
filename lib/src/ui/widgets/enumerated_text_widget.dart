import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/utils/enumeration.dart';

class EnumeratedTextWidget extends StatelessWidget {
  final Enumeration _enumeration;

  EnumeratedTextWidget(this._enumeration);

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _enumeration.valueIndex,
      children: _enumeration.allValues.map((x) => Text(x)).toList(),
    );
  }
}
