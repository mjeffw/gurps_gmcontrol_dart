import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/combatant_widget.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/default_app_bar.dart';

/// The app page that represents a single combat or melee. Initialized
/// with the ID of the Melee model.
class MeleeView extends StatelessWidget {
  final int _id;
  MeleeView(this._id);

  @override
  Widget build(BuildContext context) {
    final MeleeBloc meleeBloc = BlocProvider.of<MeleeBloc>(context);

    /// Ask the melee BLoC to add the melee object associated with this ID
    meleeBloc.meleeEventSink.add(_id);

    return Scaffold(
      appBar: DefaultAppBar(titleText: 'GMCONTROL MELEE'),
      body: Column(children: [Expanded(child: _listView(context, meleeBloc))]),
    );
  }

  Widget _listView(BuildContext context, MeleeBloc meleeBloc) {
    return StreamBuilder<Melee>(
        stream: meleeBloc.meleeDataStream.where((t) => t.id == _id),
        builder: (BuildContext context, AsyncSnapshot<Melee> snapshot) {
          var builder = ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _buildCombatant(_id, index, snapshot.data);
            },
            itemCount:
                snapshot.data == null ? 0 : snapshot.data.combatants.length,
          );
          return builder;
        });
  }

  Widget _buildCombatant(int meleeId, int index, Melee data) {
    final Combatant combatant = (data != null && data.combatants.length > index)
        ? data.combatants[index]
        : null;
    if (combatant == null) {
      return Center(child: CircularProgressIndicator());
    }

    return CombatantWidget(meleeId, combatant, index);
  }
}
