import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/styles.dart';
import 'package:gurps_gmcontrol_dart/widgets/enumerated_text_widget.dart';

var _spacer = Container(width: 10);
const stunnedIcon = '\uf567';
const normalIcon = '\uf118';

class CombatantWidget extends StatelessWidget {
  final int _meleeId;
  final Combatant _combatant;
  final bool _expanded;

  const CombatantWidget(
    this._meleeId,
    this._combatant,
    this._expanded, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MeleeBloc meleeBloc = BlocProvider.of<MeleeBloc>(context);

    var widget = StreamBuilder<MeleeCombatant>(
      stream: meleeBloc.outSelectedCombatants
          .where((t) => t.id == _combatant.id && t.meleeId == _meleeId),
      builder: (BuildContext context, AsyncSnapshot<MeleeCombatant> snapshot) {
        return Container(
          padding: EdgeInsets.all(8.0),
          child: _mainWidget(meleeBloc.inSelectedCombatants,
              snapshot.data != null && snapshot.data.id == _combatant.id),
        );
      },
    );

    return widget;
  }

  Widget _mainWidget(Sink<MeleeCombatant> inSelectedCombatants, bool expanded) {
    if (expanded) {
      return Column(children: <Widget>[_headerRow(inSelectedCombatants)]);
    } else {
      return _headerRow(inSelectedCombatants);
    }
  }

  Row _headerRow(Sink<MeleeCombatant> inSelectedCombatants) {
    return Row(
      children: <Widget>[
        _gripWidget(),
        _spacer,
        GestureDetector(
          onTap: () {
            inSelectedCombatants
                .add(MeleeCombatant(id: _combatant.id, meleeId: _meleeId));
          },
          child: Text(
            _combatant.speed.toStringAsFixed(2),
          ),
        ),
        _spacer,
        Expanded(
            child:
                Text(_combatant.name, style: Styles.nameTextStyle(_expanded))),
        _spacer,
        EnumeratedTextWidget(_combatant.condition.posture),
        _spacer,
        _stunnedWidget(_combatant.condition.stunned),
        _spacer,
        EnumeratedTextWidget(_combatant.condition.maneuver),
        _spacer,
        EnumeratedTextWidget(_combatant.condition.fpCondition),
        _spacer,
        EnumeratedTextWidget(_combatant.condition.hpCondition),
      ],
    );
  }

  Widget _gripWidget() {
    var textStyle = TextStyle(
      fontFamily: 'FontAwesome Solid',
      fontSize: 16.0,
      color: Colors.grey,
    );

    return Text('\uf7a4', style: textStyle);
  }

  Widget _stunnedWidget(bool stunned) {
    var textStyle = TextStyle(
      fontFamily: 'FontAwesome Solid',
      fontSize: 20.0,
      color: stunned ? Colors.red.shade800 : Colors.green.shade600,
    );

    return Text(stunned ? stunnedIcon : normalIcon, style: textStyle);
  }
}
