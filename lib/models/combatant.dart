import 'package:flutter/foundation.dart';

class Combatant {
  final int id;
  final String name;
  final double speed;
  final Condition condition;
  final PrimaryAttributes primaryAttrs;

  Combatant(
      {this.name, this.condition, this.speed, this.primaryAttrs, this.id});

  Combatant.fromJSON(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
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
  near_death,
  dead,
  destroyed
}

class HpCondition implements Enumeration {
  static const DAMAGE = 'damage';
  static const HP = 'HP';
  static const DEAD = 'dead';
  static const _values = <String>[
    'Normal',
    'Reeling',
    'Hanging On',
    'Near Death',
    'Dead',
    'Destroyed'
  ];

  final int hitPoints;
  final int damage;
  final bool deathOverride;
  final HpConditionValue value;

  HpCondition(
      {@required this.hitPoints,
      @required this.damage,
      this.deathOverride = false})
      : value = _calculateHpCondition(hitPoints, damage, deathOverride);

  HpCondition.fromJSON(json)
      : damage = json[DAMAGE] as int,
        hitPoints = json[HP] as int,
        deathOverride = json[DEAD] as bool,
        value = _calculateHpCondition(
            json[HP] as int, json[DAMAGE] as int, json[DEAD] as bool);

  @override
  int get valueIndex => value.index;

  @override
  List<String> get allValues => _values;

  @override
  String get textValue => _values[value.index];

  static HpConditionValue _calculateHpCondition(
      int max, int damage, bool death) {
    var remaining = max - damage;
    if (death)
      return HpConditionValue.dead;
    else if (_isReeling(remaining, max))
      return HpConditionValue.reeling;
    else if (_isHangingOn(remaining, max))
      return HpConditionValue.hanging_on;
    else if (_isRiskingDeath(remaining, max))
      return HpConditionValue.near_death;
    else if (_isDead(remaining, max))
      return HpConditionValue.dead;
    else if (_isDestroyed(remaining, max))
      return HpConditionValue.destroyed;
    else
      return HpConditionValue.normal;
  }

  /// Less than 1/3 of your HP left: Reeling
  static bool _isReeling(int remaining, int maxHitPoints) =>
      remaining <= maxHitPoints / 3.0 && remaining > 0;

  /// 0 HP or less: Hanging on
  static bool _isHangingOn(int remaining, int maxHitPoints) =>
      remaining <= 0 && remaining > -1 * maxHitPoints;

  /// -1 x HP: Near death
  static bool _isRiskingDeath(int remaining, int maxHitPoints) =>
      remaining <= -1 * maxHitPoints && remaining > -5 * maxHitPoints;

  /// -5 x HP: Dead
  static bool _isDead(int remaining, int maxHitPoints) =>
      remaining <= -5 * maxHitPoints && remaining > -10 * maxHitPoints;

  /// -10 x HP: Destroyed
  static bool _isDestroyed(int remaining, int maxHitPoints) =>
      remaining <= (-10 * maxHitPoints);
}

enum FpConditionValue { normal, very_tired, near_collapse, collapse }

class FpCondition implements Enumeration {
  static const FP = 'FP';
  static const FATIGUE = 'fatigue';
  static const _values = ['Normal', 'Very Tired', 'Near Collapse', 'Collapse'];

  final int fatiguePoints;
  final int fatigue;
  final FpConditionValue value;

  FpCondition({@required this.fatiguePoints, @required this.fatigue})
      : value = _calculateCondition(fatiguePoints, fatigue);

  List<String> get allValues => _values;
  int get valueIndex => value.index;
  String get textValue => _values[value.index];

  FpCondition.fromJSON(Map<String, dynamic> json)
      : fatiguePoints = json[FP] as int,
        fatigue = json[FATIGUE] as int,
        value = _calculateCondition(json[FP] as int, json[FATIGUE] as int);

  static FpConditionValue _calculateCondition(int max, int fatigue) {
    var remaining = max - fatigue;
    if (_isVeryTired(remaining, max))
      return FpConditionValue.very_tired;
    else if (_isNearCollapse(remaining, max))
      return FpConditionValue.near_collapse;
    else if (_isCollapsed(remaining, max))
      return FpConditionValue.collapse;
    else
      return FpConditionValue.normal;
  }

  /// Less than 1/3 of your FP left: Very Tired.
  static bool _isVeryTired(int remaining, int max) =>
      remaining < (max / 3.0) && remaining > 0;

  /// 0 FP or less: Near Collapse
  static bool _isNearCollapse(int remaining, int max) =>
      remaining <= 0 && remaining > (-1 * max);

  /// -1 x FP or less: Collapse
  static bool _isCollapsed(int remaining, int max) => remaining <= (-1 * max);
}
