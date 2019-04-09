import 'package:gurps_gmcontrol_dart/models/combatant.dart';

class MockCombatant {
  static List<Combatant> fetchAll() {
    return <Combatant>[
      Combatant(
        name: 'Grend Gnashtooth',
        speed: 6.75,
        condition: Condition(
          fpCondition: FpCondition(maxFatiguePoints: 12, fatiguePoints: 3),
          hpCondition: HpCondition(maxHitPoints: 15, hitPoints: 15),
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
          fpCondition: FpCondition(maxFatiguePoints: 12, fatiguePoints: -11),
          hpCondition: HpCondition(maxHitPoints: 12, hitPoints: -3),
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
          fpCondition: FpCondition(maxFatiguePoints: 12, fatiguePoints: -12),
          hpCondition: HpCondition(maxHitPoints: 12, hitPoints: 1),
          posture: Posture(PostureValue.kneeling),
          stunned: false,
          maneuver: Maneuver(ManeuverValue.move_and_attack),
        ),
        primaryAttrs: PrimaryAttributes(st: 14, dx: 12, iq: 11, ht: 13),
      )
    ];
  }
}
