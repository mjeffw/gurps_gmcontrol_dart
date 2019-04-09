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

  PrimaryAttributes({this.st, this.dx, this.iq, this.ht});

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
  String get value;
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

  PostureValue _value;

  Posture(this._value);

  Posture.fromJSON(json)
      : _value = PostureValue.values.firstWhere(
            (e) => e.toString().split('.')[1] == json['posture'] as String);

  List<String> get allValues => _postures;
  int get valueIndex => _value.index;
  String get value => _postures[_value.index];
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

  ManeuverValue _value;

  Maneuver(this._value);

  Maneuver.fromJSON(json)
      : _value = ManeuverValue.values.firstWhere(
            (e) => e.toString().split('.')[1] == json['maneuver'] as String);

  List<String> get allValues => _values;
  int get valueIndex => _value.index;
  String get value => _values[_value.index];
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
  final HpConditionValue condition;

  HpCondition({this.maxHitPoints, this.hitPoints, this.deathOverride = false})
      : condition =
            _calculateHpCondition(maxHitPoints, hitPoints, deathOverride);

  HpCondition.fromJSON(json)
      : hitPoints = json[HP] as int,
        maxHitPoints = json[MAX] as int,
        deathOverride = json[DEAD] as bool,
        condition = _calculateHpCondition(
            json[MAX] as int, json[HP] as int, json[DEAD] as bool);

  @override
  int get valueIndex => condition.index;

  @override
  List<String> get allValues => _values;

  @override
  String get value => _values[condition.index];

  static HpConditionValue _calculateHpCondition(
      int maxHitPoints, int hitPoints, bool deathOverride) {
    if (deathOverride)
      return HpConditionValue.dead;
    else if (_isReeling(hitPoints, maxHitPoints))
      return HpConditionValue.reeling;
    else if (_isHangingOn(hitPoints, maxHitPoints))
      return HpConditionValue.hanging_on;
    else if (_isRiskingDeath(hitPoints, maxHitPoints))
      return HpConditionValue.risking_death;
    else if (_isDead(hitPoints, maxHitPoints))
      return HpConditionValue.dead;
    else if (_isDestroyed(hitPoints, maxHitPoints))
      return HpConditionValue.destroyed;
    else
      return HpConditionValue.normal;
  }

  static bool _isDestroyed(int hitPoints, int maxHitPoints) {
    return hitPoints <= (-10 * maxHitPoints);
  }

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
  final FpConditionValue condition;

  FpCondition({@required this.maxFatiguePoints, @required this.fatiguePoints})
      : condition = _calculateCondition(maxFatiguePoints, fatiguePoints);

  List<String> get allValues => _values;
  int get valueIndex => condition.index;
  String get value => _values[condition.index];

  FpCondition.fromJSON(json)
      : maxFatiguePoints = json[MAX] as int,
        fatiguePoints = json[FP] as int,
        condition = _calculateCondition(json[MAX] as int, json[FP] as int);

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
