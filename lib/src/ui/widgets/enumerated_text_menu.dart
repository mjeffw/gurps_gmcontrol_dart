import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_widget.dart';
import 'package:gurps_gmcontrol_dart/src/utils/enumeration.dart';

class EnumeratedTextMenu extends StatelessWidget {
  final Enumeration enumeration;
  final PopupMenuItemSelected<String> onSelected;

  EnumeratedTextMenu({this.enumeration, this.onSelected});

  @override
  Widget build(BuildContext context) {
    var menu = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: enumeration.allValues),
        onConfirm: (Picker _, List<int> selected) =>
            onSelected(enumeration.allValues[selected[0]]),
        selecteds: [
          enumeration.valueIndex,
        ]);

    return FlatButton(
      padding: EdgeInsets.all(0.0),
      child: EnumeratedTextWidget(enumeration),
      onPressed: () => menu.showModal(context),
    );

    // return PopupMenuButton<String>(
    //     onSelected: onSelected,
    //     child: EnumeratedTextWidget(enumeration),
    //     itemBuilder: (BuildContext context) {
    //       var list = <PopupMenuEntry<String>>[];
    //       enumeration.allValues.forEach((f) {
    //         list.add(PopupMenuItem(
    //           value: f,
    //           child: Text(f),
    //         ));
    //       });
    //       return list;
    //     });
  }
}
