import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/models/melee.dart';
import 'package:gurps_gmcontrol_dart/widgets/combatant_widget.dart';
import 'package:gurps_gmcontrol_dart/widgets/default_app_bar.dart';

class MeleeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MeleeBloc meleeBloc = BlocProvider.of<MeleeBloc>(context);
    var widget = Scaffold(
      appBar: DefaultAppBar(titleText: 'GMCONTROL MELEE'),
      body: Column(children: [
        Expanded(child: _listView(context, meleeBloc)),
      ]),
    );

    Timer(Duration(seconds: 3), () {
      meleeBloc.inMeleeId.add(0);
    });

    return widget;
  }

  Widget _listView(BuildContext context, MeleeBloc meleeBloc) {
    return StreamBuilder<Melee>(
        stream: meleeBloc.outMeleeList.where((t) => t.id == 0),
        builder: (BuildContext context, AsyncSnapshot<Melee> snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _buildCombatant(meleeBloc, index, snapshot.data);
            },
            itemCount:
                snapshot.data == null ? 0 : snapshot.data.combatants.length,
          );
        });
  }

  Widget _buildCombatant(MeleeBloc bloc, int index, Melee data) {
    final Combatant combatant = (data != null && data.combatants.length > index)
        ? data.combatants[index]
        : null;
    if (combatant == null) {
      return Center(child: CircularProgressIndicator());
    }

    return CombatantWidget(combatant, false);
  }
}
