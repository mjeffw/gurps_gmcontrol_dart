import 'package:flutter/foundation.dart';

class Combatant {
  final String name;
  final double speed;
  final Condition condition;
  final PrimaryAttributes primaryAttrs;

  Combatant({this.name, this.condition, this.speed, this.primaryAttrs});

  Combatant.fromJSON(Map<String, dynamic> json)
      : name = json['name'] as String,
        speed = json['speed'] as double,
        condition = Condition.fromJSON(json['condition']),
        primaryAttrs = PrimaryAttributes.fromJSON(json['primaryAttributes']);
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

  Condition.fromJSON(json)
      : fpCondition = FpCondition.fromJSON(json['fpCondition']),
        hpCondition = HpCondition.fromJSON(json['hpCondition']),
        stunned = json['stunned'] as bool,
        posture = Posture.fromJSON(json['posture']),
        maneuver = Maneuver.fromJSON(json['maneuver']);
}

class PrimaryAttributes {
  final int st;
  final int dx;
  final int iq;
  final int ht;

  PrimaryAttributes({this.st = 10, this.dx = 10, this.iq = 10, this.ht = 10});

  PrimaryAttributes.fromJSON(json)
      : st = json['ST'] as int,
        dx = json['DX'] as int,
        iq = json['IQ'] as int,
        ht = json['HT'] as int;
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
  List<String> get allValues;
  int get valueIndex;
  String get textValue;
}

class Posture implements Enumeration {
  static const _postures = [
    'STANDING',
    'SITTING',
    'KNEELING',
    'CRAWLING',
    'LIE PRONE',
    'LIE FACE UP'
  ];

  PostureValue value;

  Posture({this.value = PostureValue.standing});

  Posture.fromJSON(json)
      : value = PostureValue.values.firstWhere(
            (e) => e.toString().split('.')[1] == json['value'] as String);

  List<String> get allValues => _postures;
  int get valueIndex => value.index;
  String get textValue => _postures[value.index];
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
  static const _values = <String>[
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

  ManeuverValue value;

  Maneuver({this.value = ManeuverValue.do_nothing});

  Maneuver.fromJSON(json)
      : value = ManeuverValue.values.firstWhere(
            (e) => e.toString().split('.')[1] == json['value'] as String);

  List<String> get allValues => _values;
  int get valueIndex => value.index;
  String get textValue => _values[value.index];
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
  static const HP = 'HP';
  static const MAX = 'maxHP';
  static const DEAD = 'dead';
  static const _values = <String>[
    'Normal',
    'Reeling',
    'Hanging On',
    'Risk Death',
    'Dead',
    'Destroyed'
  ];

  final int maxHitPoints;
  final int hitPoints;
  final bool deathOverride;
  final HpConditionValue value;

  HpCondition(
      {@required this.maxHitPoints,
      @required this.hitPoints,
      this.deathOverride = false})
      : value = _calculateHpCondition(maxHitPoints, hitPoints, deathOverride);

  HpCondition.fromJSON(json)
      : hitPoints = json[HP] as int,
        maxHitPoints = json[MAX] as int,
        deathOverride = json[DEAD] as bool,
        value = _calculateHpCondition(
            json[MAX] as int, json[HP] as int, json[DEAD] as bool);

  @override
  int get valueIndex => value.index;

  @override
  List<String> get allValues => _values;

  @override
  String get textValue => _values[value.index];

  static HpConditionValue _calculateHpCondition(int max, int hp, bool death) {
    if (death)
      return HpConditionValue.dead;
    else if (_isReeling(hp, max))
      return HpConditionValue.reeling;
    else if (_isHangingOn(hp, max))
      return HpConditionValue.hanging_on;
    else if (_isRiskingDeath(hp, max))
      return HpConditionValue.risking_death;
    else if (_isDead(hp, max))
      return HpConditionValue.dead;
    else if (_isDestroyed(hp, max))
      return HpConditionValue.destroyed;
    else
      return HpConditionValue.normal;
  }

  static bool _isDestroyed(int hitPoints, int maxHitPoints) =>
      hitPoints <= (-10 * maxHitPoints);

  static bool _isDead(int hitPoints, int maxHitPoints) =>
      hitPoints <= -5 * maxHitPoints && hitPoints > -10 * maxHitPoints;
  static bool _isRiskingDeath(int hitPoints, int maxHitPoints) =>
      hitPoints <= -1 * maxHitPoints && hitPoints > -5 * maxHitPoints;
  static bool _isHangingOn(int hitPoints, int maxHitPoints) =>
      hitPoints <= 0 && hitPoints > -1 * maxHitPoints;
  static bool _isReeling(int hitPoints, int maxHitPoints) =>
      hitPoints <= maxHitPoints / 3.0 && hitPoints > 0;
}

enum FpConditionValue { normal, very_tired, near_collapse, collapse }

class FpCondition implements Enumeration {
  static const MAX = 'maxFP';
  static const FP = 'FP';
  static const _values = ['Normal', 'Very Tired', 'Near Collapse', 'Collapse'];

  final int maxFatiguePoints;
  final int fatiguePoints;
  final FpConditionValue value;

  FpCondition({@required this.maxFatiguePoints, @required this.fatiguePoints})
      : value = _calculateCondition(maxFatiguePoints, fatiguePoints);

  List<String> get allValues => _values;
  int get valueIndex => value.index;
  String get textValue => _values[value.index];

  FpCondition.fromJSON(Map<String, dynamic> json)
      : maxFatiguePoints = json[MAX] as int,
        fatiguePoints = json[FP] as int,
        value = _calculateCondition(json[MAX] as int, json[FP] as int);

  static FpConditionValue _calculateCondition(int max, int fp) {
    if (_isVeryTired(fp, max))
      return FpConditionValue.very_tired;
    else if (_isNearCollapse(fp, max))
      return FpConditionValue.near_collapse;
    else if (_isCollapsed(fp, max))
      return FpConditionValue.collapse;
    else
      return FpConditionValue.normal;
  }

  static bool _isCollapsed(int fp, int max) => fp <= (-1 * max);
  static bool _isNearCollapse(int fp, int max) => fp <= 0 && fp > (-1 * max);
  static bool _isVeryTired(int fp, int max) => fp < (max / 3.0) && fp > 0;
}
