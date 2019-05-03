import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/styles.dart';
import 'package:gurps_gmcontrol_dart/widgets/enumerated_text_menu.dart';
import 'package:gurps_gmcontrol_dart/widgets/enumerated_text_widget.dart';

const normalIcon = '\uf118';
const stunnedIcon = '\uf567';
var _smallSpacer = Container(width: 4);
var _spacer = Container(width: 10);

class CombatantWidget extends StatelessWidget {
  final int _meleeId;
  final Combatant _combatant;
  final bool _expanded;
  final int _index;

  const CombatantWidget(
    this._meleeId,
    this._combatant,
    this._expanded,
    this._index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool wideScreen = (MediaQuery.of(context).size.width > 600);

    final MeleeBloc meleeBloc = BlocProvider.of<MeleeBloc>(context);

    var widget = StreamBuilder<CombatantSelectionId>(
      stream: meleeBloc.outSelectedCombatants.where((t) => _isSameCombatant(t)),
      builder: (BuildContext _, AsyncSnapshot<CombatantSelectionId> snapshot) {
        var expanded = _isSelected(snapshot);
        Color background =
            expanded ? Colors.amber : _isOdd() ? Colors.white : Colors.white;

        return Container(
            color: background,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              children: <Widget>[
                _gripWidget(),
                _spacer,
                Expanded(
                    child: _mainWidget(
                        meleeBloc.inSelectedId, wideScreen, expanded)),
              ],
            ));
      },
    );

    return widget;
  }

  Widget _mainWidget(
      Sink<CombatantId> inSelection, bool widescreen, bool expanded) {
    if (expanded) {
      return Column(
        children: <Widget>[
          _headerRow(widescreen, inSelection),
          _secondaryRow(),
        ],
      );
    } else {
      return Column(
        children: <Widget>[_headerRow(widescreen, inSelection)],
      );
    }
  }

  Widget _headerRow(bool widescreen, Sink<CombatantId> inSelection) {
    if (!widescreen) {
      return Column(
        children: <Widget>[
          Row(children: _headerWidgets1(inSelection)),
          Row(
            children: <Widget>[]
              ..add(Expanded(child: _spacer))
              ..addAll(_headerWidgets2())
              ..toList(),
          ),
        ],
      );
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[]
            ..addAll(_headerWidgets1(inSelection))
            ..addAll(_headerWidgets2())
            ..toList(),
        ),
      ],
    );
  }

  List<Widget> _headerWidgets1(Sink<CombatantId> inSelectedCombatants) {
    return <Widget>[
      Expanded(
        child: GestureDetector(
          onTap: () {
            inSelectedCombatants
                .add(CombatantId(id: _combatant.id, meleeId: _meleeId));
          },
          child: Text(
            _combatant.name,
            style: Styles.nameTextStyle(_expanded),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      _spacer,
      EnumeratedTextWidget(_combatant.condition.posture),
      _spacer,
      _stunnedWidget(_combatant.condition.stunned),
    ];
  }

  List<Widget> _headerWidgets2() {
    return <Widget>[
      _spacer,
      EnumeratedTextMenu(
          enumeration: _combatant.condition.maneuver,
          onSelected: (String f) {}),
      // EnumeratedTextWidget(_combatant.condition.maneuver),
      _spacer,
      EnumeratedTextWidget(_combatant.condition.fpCondition),
      _spacer,
      EnumeratedTextWidget(_combatant.condition.hpCondition),
    ];
  }

  Row _secondaryRow() {
    return Row(
      children: <Widget>[
        _basicAttributes(),
        _spacer,
        _secondaryAttributes(),
      ],
    );
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

  Widget _gripWidget() {
    var textStyle = TextStyle(
      fontFamily: 'FontAwesome Solid',
      fontSize: 16.0,
      color: Colors.grey,
    );

    return Text('\uf7a4', style: textStyle);
  }

  bool _isOdd() => (_index % 2 != 0);

  bool _isSameCombatant(CombatantSelectionId t) =>
      t.combatantId.id == _combatant.id && t.combatantId.meleeId == _meleeId;

  bool _isSelected(AsyncSnapshot<CombatantSelectionId> snapshot) =>
      snapshot.data != null && snapshot.data.selected;

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

  Widget _stunnedWidget(bool stunned) {
    var textStyle = TextStyle(
      fontFamily: 'FontAwesome Solid',
      fontSize: 20.0,
      color: stunned ? Colors.red.shade800 : Colors.green.shade600,
    );

    return Text(stunned ? stunnedIcon : normalIcon, style: textStyle);
  }

  TableRow _tableRow(String label, String data) {
    return TableRow(
      children: <Widget>[
        Text(
          label,
          style: Styles.labelStyle(),
          textAlign: TextAlign.left,
        ),
        _smallSpacer,
        Text(data, textAlign: TextAlign.left, style: Styles.attributeStyle())
      ],
    );
  }
}
