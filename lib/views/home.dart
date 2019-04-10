import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/views/melee.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GMCONTROL')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Melee'),
              onPressed: () {
                _openPage(context);
              },
            ),
            RaisedButton(
              child: Text('Another Page'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _openPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return BlocProvider<MeleeBloc>(
        bloc: MeleeBloc(),
        child: MeleeView(),
      );
    }));
  }
}
