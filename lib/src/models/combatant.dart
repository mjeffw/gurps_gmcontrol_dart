import 'package:flutter/widgets.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/utils/enumeration.dart';

enum FpCondition { normal, very_tired, near_collapse, collapse }

///
/// FpCondition represents the combatant's status as related to accumulated
/// fatigue loss. There are two values tracked: the maximum FP and the
/// combatant's current fatigue loss.
///
class FpConditionEnum implements Enumeration {
  static const _values = ['Normal', 'Very Tired', 'Near Collapse', 'Collapse'];

  /// Maximum FP
  final int fp;

  /// Accumulated fatigue loss.
  final int fatigueLoss;

  /// Effects of accumulated fatigue loss.
  final FpCondition value;

  FpConditionEnum({@required this.fp, @required this.fatigueLoss})
      : assert(fatigueLoss != null),
        assert(fp != null),
        value = _calculateCondition(fp, fatigueLoss);

  @override
  List<String> get allValues => _values;

  @override
  int get valueIndex => value.index;

  @override
  String get textValue => _values[value.index];

  static FpCondition _calculateCondition(int max, int fatigue) {
    var remaining = max - fatigue;
    if (_isVeryTired(remaining, max))
      return FpCondition.very_tired;
    else if (_isNearCollapse(remaining, max))
      return FpCondition.near_collapse;
    else if (_isCollapsed(remaining, max))
      return FpCondition.collapse;
    else
      return FpCondition.normal;
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

enum HpCondition { normal, reeling, hanging_on, near_death, dead, destroyed }

///
/// HpCondition represents the combatant's health due to injury. It tracks two
/// main values: the maximum hit points of the character, and the current
/// amount of injury taken.
///
/// In addition, the deathOverride is used to mark the combatant as dead
/// regardless of injury. This may come from magic or GM fiat or a failed HT
/// check while in the Near Death condition, etc.
///
class HpConditionEnum implements Enumeration {
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
  final bool failedDeathCheck;

  /// Effects of accumulated injury.
  final HpCondition value;

  HpConditionEnum(
      {@required this.hitPoints,
      @required this.injury,
      @required this.failedDeathCheck})
      : assert(hitPoints != null),
        assert(injury != null),
        value = _calculateHpCondition(hitPoints, injury, failedDeathCheck);

  @override
  int get valueIndex => value.index;

  @override
  List<String> get allValues => _values;

  @override
  String get textValue => _values[value.index];

  static HpCondition _calculateHpCondition(int max, int injury, bool death) {
    var remaining = max - injury;
    if (_isDestroyed(remaining, max))
      return HpCondition.destroyed;
    else if (_isDead(remaining, max))
      return HpCondition.dead;
    else if (death)
      return HpCondition.dead;
    else if (_isReeling(remaining, max))
      return HpCondition.reeling;
    else if (_isHangingOn(remaining, max))
      return HpCondition.hanging_on;
    else if (_isRiskingDeath(remaining, max))
      return HpCondition.near_death;
    else
      return HpCondition.normal;
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

enum Posture { standing, sitting, kneeling, crawling, lie_prone, lie_face_up }

///
/// Postures: standing, sitting, kneeling, crawling, lying prone (face down),
/// and lying face up.
///
class PostureEnum implements Enumeration {
  static const _postures = [
    'STANDING',
    'SITTING',
    'KNEELING',
    'CRAWLING',
    'LIE PRONE',
    'LIE FACE UP'
  ];

  static Posture fromJSON(Map<String, dynamic> json) =>
      Posture.values.firstWhere(
          (e) => e.toString().split('.')[1] == json['posture'] as String);

  Posture value;

  PostureEnum({this.value = Posture.standing}) : assert(value != null);

  @override
  List<String> get allValues => _postures;

  @override
  int get valueIndex => value.index;

  @override
  String get textValue => _postures[value.index];
}

enum Maneuver {
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
class ManeuverEnum implements Enumeration {
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

  static Maneuver fromJSON(Map<String, dynamic> json) =>
      Maneuver.values.firstWhere(
          (e) => e.toString().split('.')[1] == json['maneuver'] as String);

  Maneuver value;

  ManeuverEnum({this.value = Maneuver.do_nothing}) : assert(value != null);

  @override
  List<String> get allValues => _values;

  @override
  int get valueIndex => value.index;

  @override
  String get textValue => _values[value.index];
}

///
/// Condition is an object that aggregates all the various conditions that
/// matter during combat.
///
class Condition {
  final int fatigue;
  final int injury;
  final bool stunned;
  final bool failedDeathCheck;
  final Posture posture;
  final Maneuver maneuver;

  const Condition(
      {this.fatigue = 0,
      this.injury = 0,
      this.maneuver = Maneuver.do_nothing,
      this.posture = Posture.standing,
      this.failedDeathCheck = false,
      this.stunned = false})
      : assert(fatigue != null),
        assert(injury != null),
        assert(maneuver != null),
        assert(posture != null),
        assert(failedDeathCheck != null),
        assert(stunned != null);

  Condition.fromJSON(Map<String, dynamic> json)
      : this(
            fatigue: json['fatigue'] as int,
            injury: json['injury'] as int,
            stunned: json['stunned'] as bool,
            failedDeathCheck: json['failedDeathCheck'] as bool,
            posture: PostureEnum.fromJSON(json),
            maneuver: ManeuverEnum.fromJSON(json));
}

typedef Character CharacterFactory(int id);

///
/// Combatant wraps a Character and includes any data needed to be tracked in
/// a melee.
///
/// The Character's ID is stored here, to have a real Combatant the character
/// info has to be read.
///
class Combatant with ChangeNotifier {
  final int id;
  final Condition condition;
  final Character character;

  Combatant(
      {@required this.id,
      @required this.character,
      this.condition = const Condition()})
      : assert(id != null),
        assert(condition != null);

  Combatant.fromJSON(Map<String, dynamic> json)
      : this(
            id: json['id'] as int,
            condition: Condition.fromJSON(json['condition']),
            character: null);

  FpConditionEnum get fpCondition => FpConditionEnum(
      fp: character.secondaryAttrs.fp, fatigueLoss: condition.fatigue);

  PostureEnum get posture => PostureEnum(value: condition.posture);

  ManeuverEnum get maneuver => ManeuverEnum(value: condition.maneuver);

  HpConditionEnum get hpCondition => HpConditionEnum(
      hitPoints: character.secondaryAttrs.hp,
      injury: condition.injury,
      failedDeathCheck: condition.failedDeathCheck);

  void setManeuver(String text) {
    Maneuver m = Maneuver.values.firstWhere((it) => it.toString() == text);
    maneuver.value = m;
    notifyListeners();
  }
}
