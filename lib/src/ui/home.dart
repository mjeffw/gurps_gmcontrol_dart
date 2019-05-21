import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/apis/melee_api.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/default_app_bar.dart';
import 'package:provider/provider.dart';

import 'melee_view.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(titleText: 'GMCONTROL'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
                child: Text('Melee'), onPressed: () => _openMeleeView(context)),
            RaisedButton(child: Text('Another Page'), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  void _openMeleeView(BuildContext context) {
    meleeApi.fetch(index: 0).then((Melee m) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider<Melee>(
                builder: (_) => m,
                child: MeleeView(),
              ),
        ),
      );
    });
  }
}
