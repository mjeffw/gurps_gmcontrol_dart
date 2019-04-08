import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  Playground();

  @override
  PlaygroundState createState() => PlaygroundState();
}

class PlaygroundState extends State<Playground> {
  int index = 0;

  void _incrementCounter() {
    setState(() {
      index = (index + 1) % Hitpoints.values.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Locations")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // FatigueIcon(value: fatigue.values[index]),
            HitpointsIcon(value: Hitpoints.values[index])
          ],
        ),
      ),
      // Floating action buttons are special button
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}

enum Fatigue { rested, very_tired, near_collapse, collapse }

@immutable
class FatigueIcon extends StatelessWidget {
  FatigueIcon({
    Key key,
    @required this.value,
  }) : super(key: key);

  final Fatigue value;

  final icons = <Widget>[
    _buildText('\uf118', Colors.green),
    _buildText('\uf57f', Colors.amber.shade700),
    _buildText('\uf5c8', Colors.red),
    _buildText('\uf567', Colors.black)
  ];

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: value.index,
      children: icons,
    );
  }
}

const _fontSize = 50.0;
var _textStyle = TextStyle(
    fontFamily: 'FontAwesome',
    fontSize: _fontSize,
    color: Colors.black,
    fontWeight: FontWeight.w400);

Widget _buildText(String text, Color color) {
  return Text(text, style: _textStyle.apply(color: color));
}

Widget _buildTextWithOverlay(String text, Color color, String overlayText) {
  Text base = Text(text, style: _textStyle.apply(color: color));

  var overlay = Text(overlayText,
      style: TextStyle(
          fontSize: _fontSize * 0.3,
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(
              // bottomLeft
              offset: Offset(-1.5, -1.5),
              color: Colors.white,
            ),
            Shadow(
              // bottomRight
              offset: Offset(1.5, -1.5),
              color: Colors.white,
            ),
            Shadow(
              // topRight
              offset: Offset(1.5, 1.5),
              color: Colors.white,
            ),
            Shadow(
              // topLeft
              offset: Offset(-1.5, 1.5),
              color: Colors.white,
            ),
          ]));

  Stack stack = Stack(
    children: <Widget>[
      base,
      Positioned(child: overlay, bottom: 0.0, right: 0.0)
    ],
  );

  return stack;
}

enum Hitpoints {
  normal,
  reeling,
  risk_collapse,
  collapse,
  risk_death_1,
  risk_death_2,
  risk_death_3,
  risk_death_4,
  dead,
  destroyed
}

@immutable
class HitpointsIcon extends StatelessWidget {
  HitpointsIcon({
    Key key,
    @required this.value,
  }) : super(key: key);

  final Hitpoints value;

  final icons = <Widget>[
    _buildText('\uf70c', Colors.green),
    _buildText('\uf554', Colors.amber),
    _buildText('\uf683', Colors.orange),
    _buildText('\uf236', Colors.deepOrange),
    _buildTextWithOverlay('\uf54c', Colors.red, '×1'),
    _buildTextWithOverlay('\uf54c', Colors.red.shade600, '×2'),
    _buildTextWithOverlay('\uf54c', Colors.red.shade700, '×3'),
    _buildTextWithOverlay('\uf54c', Colors.red.shade800, '×4'),
    _buildText('\uf54c', Colors.black),
    _buildText('\uf619', Colors.deepPurple)
  ];

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: value.index,
      children: icons,
    );
  }
}

// Normal - running - https://fontawesome.com/icons/running?style=solid
// Reeling - blind - https://fontawesome.com/icons/blind?style=solid
// Risk Collapse - wheelchair - https://fontawesome.com/icons/wheelchair?style=solid
// Collapsed/Unconscious - bed - https://fontawesome.com/icons/bed?style=solid
// Risk Death x1 - skull-crossbones - https://fontawesome.com/icons/skull-crossbones?style=solid
// Risk Death x2 - skull-crossbones + 2 - https://fontawesome.com/icons/skull-crossbones?style=solid
// Risk Death x3
// Risk Death x4
// Dead - skull - https://fontawesome.com/icons/skull?style=solid
// Destroyed - poop - https://fontawesome.com/icons/poop?style=solid
