import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/ui/styles.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_widget.dart';

var _spacer = Container(width: 10);
var _smallSpacer = Container(width: 4);
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

    var widget = StreamBuilder<MeleeCombatantSelection>(
      stream: meleeBloc.outSelectedCombatants.where((t) =>
          t.combatantId.id == _combatant.id &&
          t.combatantId.meleeId == _meleeId),
      builder: (BuildContext context,
          AsyncSnapshot<MeleeCombatantSelection> snapshot) {
        return Container(
          padding: EdgeInsets.all(8.0),
          child: _mainWidget(meleeBloc.inSelectedId,
              snapshot.data != null && snapshot.data.selected),
        );
      },
    );

    return widget;
  }

  Widget _mainWidget(Sink<MeleeCombatant> inSelectedCombatants, bool expanded) {
    if (expanded) {
      return Container(
          color: Colors.amber,
          child: Column(
            children: <Widget>[
              _headerRow(inSelectedCombatants),
              Row(
                children: <Widget>[
                  _basicAttributes(),
                  _spacer,
                  _secondaryAttributes(),
                ],
              )
            ],
          ));
    } else {
      return _headerRow(inSelectedCombatants);
    }
  }

  Row _headerRow(Sink<MeleeCombatant> inSelectedCombatants) {
    return Row(
      children: <Widget>[
        _gripWidget(),
        _spacer,
        Expanded(
          child: GestureDetector(
            onTap: () {
              inSelectedCombatants
                  .add(MeleeCombatant(id: _combatant.id, meleeId: _meleeId));
            },
            child:
                Text(_combatant.name, style: Styles.nameTextStyle(_expanded)),
          ),
        ),
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

  Widget _basicAttributes() {
    var table = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _tableRow('ST', _combatant.basicAttrs.st.toString()),
        _tableRow('DX', _combatant.basicAttrs.dx.toString()),
        _tableRow('IQ', _combatant.basicAttrs.iq.toString()),
        _tableRow('HT', _combatant.basicAttrs.ht.toString())
      ],
    );
    return table;
  }

  TableRow _tableRow(String label, String data) {
    return TableRow(
      children: <Widget>[
        Text(
          label,
          style: Styles.labelStyle(),
          textAlign: TextAlign.right,
        ),
        _smallSpacer,
        Text(data, textAlign: TextAlign.left, style: Styles.attributeStyle())
      ],
    );
  }

  Widget _secondaryAttributes() {
    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _tableRow('Speed', _combatant.secondaryAttrs.speed.toString()),
        _tableRow('Per', _combatant.secondaryAttrs.per.toString()),
        _tableRow('Will', _combatant.secondaryAttrs.will.toString()),
        _tableRow('Move', _combatant.secondaryAttrs.move.toString())
      ],
    );
  }
}
