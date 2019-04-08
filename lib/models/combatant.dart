class Combatant {
  final String name;
  final double speed;
  final Condition condition;
  final PrimaryAttributes primaryAttrs;

  Combatant({this.name, this.condition, this.speed, this.primaryAttrs});
}

class Condition {
  final FpCondition fpCondition;
  final HpCondition hpCondition;
  final bool stunned;
  final Posture posture;
  final Maneuver maneuver;

  Condition(
      {this.fpCondition,
      this.hpCondition,
      this.maneuver,
      this.posture,
      this.stunned});
}

class PrimaryAttributes {
  final int st;
  final int dx;
  final int iq;
  final int ht;

  PrimaryAttributes({this.st, this.dx, this.iq, this.ht});
}

enum PostureValue {
  standing,
  sitting,
  kneeling,
  crawling,
  lie_prone,
  lie_face_up
}

abstract class Enumeration {
  List<String> allValues();
  int valueIndex();
  String value();
}

class Posture implements Enumeration {
  final _postures = [
    'STANDING',
    'SITTING',
    'KNEELING',
    'CRAWLING',
    'LIE PRONE',
    'LIE FACE UP'
  ];

  PostureValue _value;

  Posture(this._value);

  List<String> allValues() => _postures;
  int valueIndex() => _value.index;
  String value() => _postures[_value.index];
}

enum ManeuverValue {
  do_nothing,
  move,
  change_posture,
  aim,
  attack,
  feint,
  all_out_attack,
  move_and_attack,
  all_out_defense,
  concentrate,
  ready,
  wait
}

class Maneuver implements Enumeration {
  final _values = [
    'Do Nothing',
    'Move',
    'Change Posture',
    'Aim',
    'Attack',
    'Feint',
    'All-Out Attack',
    'Move and Attack',
    'All-Out Defense',
    'Concentrate',
    'Ready',
    'Wait'
  ];

  ManeuverValue _value;

  Maneuver(this._value);

  List<String> allValues() => _values;
  int valueIndex() => _value.index;
  String value() => _values[_value.index];
}

enum HpConditionValue {
  normal,
  reeling,
  hanging_on,
  risking_death,
  dead,
  destroyed
}

class HpCondition implements Enumeration {
  final _values = [
    'Normal',
    'Reeling',
    'Hanging On',
    'Risk Death',
    'Dead',
    'Destroyed'
  ];

  HpConditionValue _value;

  HpCondition(this._value);

  List<String> allValues() => _values;
  int valueIndex() => _value.index;
  String value() => _values[_value.index];
}

enum FpConditionValue { normal, very_tired, near_collapse, collapse }

class FpCondition implements Enumeration {
  final _values = ['Normal', 'Very Tired', 'Near Collapse', 'Collapse'];
  FpConditionValue _value;

  FpCondition(this._value);

  List<String> allValues() => _values;
  int valueIndex() => _value.index;
  String value() => _values[_value.index];
}
