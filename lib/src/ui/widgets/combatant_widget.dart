import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/bloc_provider.dart';
import 'package:gurps_gmcontrol_dart/src/blocs/melee_bloc.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/ui/styles.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_menu.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_widget.dart';

const normalIcon = '\uf118';
const stunnedIcon = '\uf567';
var _smallSpacer = Container(width: 4);
var _spacer = Container(width: 10);

class CombatantWidget extends StatelessWidget {
  final int _meleeId;
  final Combatant _combatant;
  final int _index;

  const CombatantWidget(
    this._meleeId,
    this._combatant,
    this._index, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wideScreen = Styles.isWidescreen(context);
    final meleeBloc = BlocProvider.of<MeleeBloc>(context);
    final selectionEventSink = meleeBloc.selectionEventSink;

    var widget = StreamBuilder<CombatantSelectionId>(
      stream: meleeBloc.outSelectedCombatants.where((t) => _isSameCombatant(t)),
      builder: (BuildContext _, AsyncSnapshot<CombatantSelectionId> snapshot) {
        final isSelected = _isSelected(snapshot);
        return Container(
          color: Styles.listRowBackground(isSelected, _index),
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Row(
            children: <Widget>[
              _gripWidget(),
              _spacer,
              Expanded(
                child: Column(children: _children(context, isSelected)),
              ),
            ],
          ),
        );
      },
    );

    return widget;
  }

  List<Widget> _children(BuildContext context, bool expanded) {
    return <Widget>[
      _headerRow(context),
      ...(expanded ? <Widget>[_secondaryRow()] : <Widget>[])
    ];
  }

  Widget _headerRow(BuildContext context) {
    final selectionEventSink =
        BlocProvider.of<MeleeBloc>(context).selectionEventSink;

    if (!Styles.isWidescreen(context)) {
      return Column(
        children: <Widget>[
          Row(children: _headerWidgets1(selectionEventSink)),
          Row(
            children: <Widget>[
              Expanded(child: _spacer),
              ..._headerWidgets2(),
            ],
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ..._headerWidgets1(selectionEventSink),
            ..._headerWidgets2(),
          ],
        ),
      ],
    );
  }

  List<Widget> _headerWidgets1(Sink<CombatantId> selectionEventSink) {
    return <Widget>[
      Expanded(
        child: GestureDetector(
          onTap: () {
            selectionEventSink
                .add(CombatantId(id: _combatant.id, meleeId: _meleeId));
          },
          child: Text(
            _combatant.name,
            style: Styles.nameTextStyle,
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

  Widget _gripWidget() => Text('\uf7a4', style: Styles.solidIconStyle);

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
    var color2 = stunned ? Colors.red.shade800 : Colors.green.shade600;

    return Text(stunned ? stunnedIcon : normalIcon,
        style:
            Styles.solidIconStyle.apply(fontSizeFactor: 1.25, color: color2));
  }

  TableRow _tableRow(String label, String data) {
    return TableRow(
      children: <Widget>[
        Text(
          label,
          style: Styles.labelStyle,
          textAlign: TextAlign.left,
        ),
        _smallSpacer,
        Text(data, textAlign: TextAlign.left, style: Styles.attributeStyle)
      ],
    );
  }
}