import 'package:flutter/foundation.dart';
import 'package:gurps_gmcontrol_dart/utils/enumeration.dart';

///
/// Represents a single participant within a Melee.
///
class Combatant {
  /// This uniquely identifies a Combatant instance.
  final int id;

  final String name;
  final Condition condition;
  final BasicAttributes basicAttrs;
  final SecondaryAttributes secondaryAttrs;

  Combatant(
      {@required this.name,
      @required this.condition,
      @required this.basicAttrs,
      @required this.secondaryAttrs,
      @required this.id})
      : assert(name != null),
        assert(condition != null),
        assert(secondaryAttrs != null),
        assert(basicAttrs != null),
        assert(id != null);

  Combatant.fromJSON(Map<String, dynamic> json)
      : this(
            id: json['id'] as int,
            name: json['name'] as String,
            condition: Condition.fromJSON(json['condition']),
            basicAttrs: BasicAttributes.fromJSON(json['basicAttributes']),
            secondaryAttrs:
                SecondaryAttributes.fromJSON(json['secondaryAttributes']));

  double get speed => secondaryAttrs.speed;
}

///
/// Condition is an object that aggregates all the various conditions that
/// matter during combat.
///
class Condition {
  final FpCondition fpCondition;
  final HpCondition hpCondition;
  final bool stunned;
  final Posture posture;
  final Maneuver maneuver;

  Condition(
      {@required this.fpCondition,
      @required this.hpCondition,
      @required this.maneuver,
      @required this.posture,
      @required this.stunned})
      : assert(fpCondition != null),
        assert(hpCondition != null),
        assert(maneuver != null),
        assert(posture != null),
        assert(stunned != null);

  Condition.fromJSON(json)
      : this(
            fpCondition: FpCondition.fromJSON(json['fpCondition']),
            hpCondition: HpCondition.fromJSON(json['hpCondition']),
            stunned: json['stunned'] as bool,
            posture: Posture.fromJSON(json['posture']),
            maneuver: Maneuver.fromJSON(json['maneuver']));
}

///
/// Represents the basic attributes of the combatant. Four numbers called
/// attributes define your basic abilities: Strength (ST), Dexterity (DX),
/// Intelligence (IQ), and Health (HT).
///
class BasicAttributes {
  /// Strength (ST) measures physical power and bulk.
  final int st;

  /// Dexterity (DX) is a composite measure of agility, coordination, and fine
  /// motor ability.
  final int dx;

  /// Intelligence (IQ) is a broad measure of brainpower: creativity, cunning,
  /// memory, reason, and so on.
  final int iq;

  /// Health is a measure of energy and vitality.
  final int ht;

  BasicAttributes({this.st = 10, this.dx = 10, this.iq = 10, this.ht = 10})
      : assert(st != null),
        assert(dx != null),
        assert(iq != null),
        assert(ht != null);

  BasicAttributes.fromJSON(json)
      : this(
            st: json['ST'] as int,
            dx: json['DX'] as int,
            iq: json['IQ'] as int,
            ht: json['HT'] as int);
}

class SecondaryAttributes {
  final int move;
  final int per;
  final double speed;
  final int will;

  SecondaryAttributes({this.speed, this.per, this.will, this.move})
      : assert(move != null),
        assert(speed != null),
        assert(will != null),
        assert(per != null);

  SecondaryAttributes.fromJSON(Map<String, dynamic> json)
      : this(
            move: json['move'] as int,
            per: json['per'] as int,
            will: json['will'] as int,
            speed: json['speed'] as double);
}

enum PostureValue {
  standing,
  sitting,
  kneeling,
  crawling,
  lie_prone,
  lie_face_up
}

///
/// Postures: standing, sitting, kneeling, crawling, lying prone (face down),
/// and lying face up.
///
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
      : this(
            value: PostureValue.values.firstWhere(
                (e) => e.toString().split('.')[1] == json['value'] as String));

  @override
  List<String> get allValues => _postures;

  @override
  int get valueIndex => value.index;

  @override
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

///
/// A maneuver is an action you can take on your turn. Each turn, you must
/// choose one maneuver. Your choice determines what you can do that turn.
///
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
      : this(
            value: ManeuverValue.values.firstWhere(
                (e) => e.toString().split('.')[1] == json['value'] as String));

  @override
  List<String> get allValues => _values;

  @override
  int get valueIndex => value.index;

  @override
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

///
/// HpCondition represents the combatant's health due to injury. It tracks two
/// main values: the maximum hit points of the character, and the current
/// amount of injury taken.
///
/// In addition, the deathOverride is used to mark the combatant as dead
/// regardless of injury. This may come from magic or GM fiat or a failed HT
/// check while in the Near Death condition, etc.
///
class HpCondition implements Enumeration {
  static const INJURY = 'injury';
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

  /// Hit Points represent your body’s ability to sustain injury.
  final int hitPoints;

  /// Injury is any temporary loss of Hit Points.
  final int injury;

  /// Use to indicate that the combatant is dead, even if not in the
  /// HpConditionValue.dead range of injury
  final bool deathOverride;

  /// Effects of accumulated injury.
  final HpConditionValue value;

  HpCondition(
      {@required this.hitPoints,
      @required this.injury,
      this.deathOverride = false})
      : value = _calculateHpCondition(hitPoints, injury, deathOverride),
        assert(hitPoints != null),
        assert(injury != null);

  HpCondition.fromJSON(json)
      : this(
            hitPoints: json[HP] as int,
            injury: json[INJURY] as int,
            deathOverride: json[DEAD] as bool);

  @override
  int get valueIndex => value.index;

  @override
  List<String> get allValues => _values;

  @override
  String get textValue => _values[value.index];

  static HpConditionValue _calculateHpCondition(
      int max, int injury, bool death) {
    var remaining = max - injury;
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

///
/// FpCondition represents the combatant's status as related to accumulated
/// fatigue loss. There are two values tracked: the maximum FP and the
/// combatant's current fatigue loss.
///
class FpCondition implements Enumeration {
  static const FP = 'FP';
  static const FATIGUE = 'fatigue';
  static const _values = ['Normal', 'Very Tired', 'Near Collapse', 'Collapse'];

  /// Fatigue Points rate your body’s "energy supply."
  final int fatiguePoints;

  /// Accumulated fatigue loss.
  final int fatigueLoss;

  /// Effects of accumulated fatigue loss.
  final FpConditionValue value;

  FpCondition({@required this.fatiguePoints, @required this.fatigueLoss})
      : value = _calculateCondition(fatiguePoints, fatigueLoss),
        assert(fatiguePoints != null),
        assert(fatigueLoss != null);

  FpCondition.fromJSON(Map<String, dynamic> json)
      : this(fatiguePoints: json[FP] as int, fatigueLoss: json[FATIGUE] as int);

  @override
  List<String> get allValues => _values;

  @override
  int get valueIndex => value.index;

  @override
  String get textValue => _values[value.index];

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
