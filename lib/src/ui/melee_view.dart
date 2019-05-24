import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/combatant_widget.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/default_app_bar.dart';
import 'package:provider/provider.dart';

/// The app page that represents a single combat or melee. Initialized
/// with the ID of the Melee model.
class MeleeView extends StatelessWidget {
  MeleeView();

  @override
  Widget build(BuildContext context) {
    final Melee melee = Provider.of<Melee>(context);

    return Scaffold(
      appBar: DefaultAppBar(
        titleText: 'GMCONTROL MELEE',
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sort to combat order',
            onPressed: () => _sortToCombatOrder(melee),
          ),
        ],
      ),
      body: Column(children: [Expanded(child: _listView(context, melee))]),
    );
  }

  Widget _listView(BuildContext context, Melee melee) {
    var list = ListView.builder(
      itemCount: melee.combatants.length,
      itemBuilder: (BuildContext context, int index) {
        var combatant = melee.combatants[index];
        return ChangeNotifierProvider<Combatant>.value(
          notifier: combatant,
          child: CombatantWidget(index: index),
        );
      },
    );
    return list;
  }

  void _sortToCombatOrder(Melee melee) {
    melee.sort();
  }
}
