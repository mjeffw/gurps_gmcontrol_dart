import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/src/ui/melee_view.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/default_app_bar.dart';

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MeleeBloc>(
        bloc: MeleeBloc(),
        child: MeleeView(0),
      );
    }));
  }
}
