import 'package:flutter/material.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/ui/styles.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_menu.dart';
import 'package:gurps_gmcontrol_dart/src/ui/widgets/enumerated_text_widget.dart';
import 'package:provider/provider.dart';

const normalIcon = '\uf118';
const stunnedIcon = '\uf567';
var _smallSpacer = Container(width: 4);
var _spacer = Container(width: 10);

class CombatantWidget extends StatefulWidget {
  final int index;

  const CombatantWidget({
    this.index,
    Key key,
  }) : super(key: key);

  @override
  _CombatantWidgetState createState() => _CombatantWidgetState();
}

class _CombatantWidgetState extends State<CombatantWidget> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final combatant = Provider.of<Combatant>(context);
    final isWideScreen = Styles.isWidescreen(context);

    print('paint');

    return Container(
      color: Styles.listRowBackground(isSelected, widget.index),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Row(
        children: <Widget>[
          _gripWidget(),
          _spacer,
          Expanded(
            child: Column(
              children: <Widget>[
                _headerRow(combatant, isWideScreen),
                if (isSelected) _secondaryRow(combatant.character)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gripWidget() => Text('\uf7a4', style: Styles.solidIconStyle);

  Widget _headerRow(Combatant combatant, bool isWidescreen) {
    if (!isWidescreen) {
      return Column(
        children: <Widget>[
          Row(children: _headerWidgets1(combatant)),
          Row(
            children: <Widget>[
              Expanded(child: _spacer),
              ..._headerWidgets2(combatant)
            ],
          ),
        ],
      );
    }

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ..._headerWidgets1(combatant),
            _spacer,
            ..._headerWidgets2(combatant),
          ],
        ),
      ],
    );
  }

  List<Widget> _headerWidgets1(Combatant combatant) {
    return <Widget>[
      Expanded(
        child: GestureDetector(
          onTap: () => setState(() => isSelected = !isSelected),
          child: Text(
            combatant.character.bio.name,
            style: Styles.nameTextStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      _spacer,
      EnumeratedTextWidget(combatant.posture),
      _spacer,
      _stunnedWidget(combatant.condition.stunned),
    ];
  }

  List<Widget> _headerWidgets2(Combatant combatant) {
    return <Widget>[
      EnumeratedTextMenu(
        enumeration: combatant.maneuver,
        onSelected: (String f) => combatant.setManeuver(f),
      ),
      _spacer,
      EnumeratedTextWidget(combatant.fpCondition),
      _spacer,
      EnumeratedTextWidget(combatant.hpCondition),
    ];
  }

  Row _secondaryRow(Character character) {
    return Row(
      children: <Widget>[
        _basicAttributes(character.basicAttrs),
        _spacer,
        _secondaryAttributes(character.secondaryAttrs),
      ],
    );
  }

  Widget _basicAttributes(BasicAttributes basicAttrs) {
    var table = Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _tableRow('ST', basicAttrs.st.toString()),
        _tableRow('DX', basicAttrs.dx.toString()),
        _tableRow('IQ', basicAttrs.iq.toString()),
        _tableRow('HT', basicAttrs.ht.toString())
      ],
    );
    return table;
  }

  Widget _secondaryAttributes(SecondaryAttributes secondaryAttrs) {
    return Table(
      defaultColumnWidth: IntrinsicColumnWidth(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _tableRow('Speed', secondaryAttrs.speed.toString()),
        _tableRow('Per', secondaryAttrs.per.toString()),
        _tableRow('Will', secondaryAttrs.will.toString()),
        _tableRow('Move', secondaryAttrs.move.toString())
      ],
    );
  }

  Widget _stunnedWidget(bool stunned) {
    return Text(stunned ? stunnedIcon : normalIcon,
        style: Styles.solidIconStyle.apply(
          fontSizeFactor: 1.25,
          color: stunned ? Colors.red.shade800 : Colors.green.shade600,
        ));
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
