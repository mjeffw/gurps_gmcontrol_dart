import 'package:flutter/material.dart';
import 'combatant_list.dart';
import 'blocs/melee_bloc.dart';
import 'blocs/bloc_provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Movies')),
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
        child: CombatantList(),
      );
    }));
  }
}
