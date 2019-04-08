import 'package:gurps_gmcontrol_dart/models/combatant.dart';

class MockCombatant {
  static List<Combatant> fetchAll() {
    return <Combatant>[
      Combatant(
        name: 'Grend Gnashtooth',
        speed: 6.75,
        condition: Condition(
          fpCondition: FpCondition(FpConditionValue.normal),
          hpCondition: HpCondition(HpConditionValue.normal),
          posture: Posture(PostureValue.crawling),
          stunned: true,
          maneuver: Maneuver(ManeuverValue.do_nothing),
        ),
        primaryAttrs: PrimaryAttributes(st: 10, dx: 14, iq: 11, ht: 9),
      ),
      Combatant(
        name: 'Foe 1',
        speed: 7.0,
        condition: Condition(
          fpCondition: FpCondition(FpConditionValue.near_collapse),
          hpCondition: HpCondition(HpConditionValue.risking_death),
          posture: Posture(PostureValue.standing),
          stunned: false,
          maneuver: Maneuver(ManeuverValue.aim),
        ),
        primaryAttrs: PrimaryAttributes(st: 14, dx: 9, iq: 8, ht: 13),
      ),
      Combatant(
        name: 'Findlay Silvermane',
        speed: 5.5,
        condition: Condition(
          fpCondition: FpCondition(FpConditionValue.collapse),
          hpCondition: HpCondition(HpConditionValue.reeling),
          posture: Posture(PostureValue.kneeling),
          stunned: false,
          maneuver: Maneuver(ManeuverValue.move_and_attack),
        ),
        primaryAttrs: PrimaryAttributes(st: 14, dx: 12, iq: 11, ht: 13),
      )
    ];
  }
}
