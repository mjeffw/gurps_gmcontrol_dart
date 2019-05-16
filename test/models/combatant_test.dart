import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('Fp Condition', () {
    test('null fatigueLoss', () {
      expect(() => FpConditionEnum(fatigueLoss: null, fp: 0),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null fatiguePoints', () {
      expect(() => FpConditionEnum(fp: null, fatigueLoss: 0),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('all values', () {
      final fp = FpConditionEnum(fatigueLoss: 0, fp: 10);
      expect(fp.allValues,
          <String>['Normal', 'Very Tired', 'Near Collapse', 'Collapse']);
    });

    test('Normal', () {
      final fp = FpConditionEnum(fp: 20, fatigueLoss: 0);
      expect(fp.value, FpCondition.normal);
      expect(fp.textValue, 'Normal');
      expect(fp.valueIndex, 0);
    });
    test('Very tired', () {
      final fp = FpConditionEnum(fp: 18, fatigueLoss: 13);
      expect(fp.value, FpCondition.very_tired);
    });
    test('Near collapse', () {
      final fp = FpConditionEnum(fp: 18, fatigueLoss: 18);
      expect(fp.value, FpCondition.near_collapse);
    });
    test('Collapsed', () {
      final fp = FpConditionEnum(fp: 18, fatigueLoss: 36);
      expect(fp.value, FpCondition.collapse);
    });
  });

  group('HpCondition', () {
    test('null hitPoints', () {
      expect(
          () => HpConditionEnum(
              hitPoints: null, injury: 10, failedDeathCheck: false),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null injury', () {
      expect(
          () => HpConditionEnum(
              hitPoints: 10, injury: null, failedDeathCheck: false),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null override', () {
      expect(
          () => HpConditionEnum(
              hitPoints: 10, injury: 12, failedDeathCheck: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('all values', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 0, failedDeathCheck: false);
      expect(hp.value, HpCondition.normal);
      expect(hp.failedDeathCheck, false);
      expect(hp.injury, 0);
      expect(hp.hitPoints, 10);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
      expect(hp.allValues, [
        'Normal',
        'Reeling',
        'Hanging On',
        'Near Death',
        'Dead',
        'Destroyed'
      ]);
    });

    test('Normal lower bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 6, failedDeathCheck: false);
      expect(hp.value, HpCondition.normal);
      expect(hp.injury, 6);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
    });

    test('Normal but with failed ht check', () {
      expect(
          HpConditionEnum(hitPoints: 10, injury: 6, failedDeathCheck: true)
              .value,
          HpCondition.dead);
    });

    test('Reeling upper bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 7, failedDeathCheck: false);
      expect(hp.value, HpCondition.reeling);
      expect(hp.injury, 7);
      expect(hp.textValue, 'Reeling');
      expect(hp.valueIndex, 1);
    });

    test('Reeling but with failed ht check', () {
      expect(
          HpConditionEnum(hitPoints: 10, injury: 7, failedDeathCheck: true)
              .value,
          HpCondition.dead);
    });

    test('Hanging On upper bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 10, failedDeathCheck: false);
      expect(hp.value, HpCondition.hanging_on);
      expect(hp.injury, 10);
      expect(hp.textValue, 'Hanging On');
      expect(hp.valueIndex, 2);
    });

    test('Hanging on but with failed ht check', () {
      expect(
          HpConditionEnum(hitPoints: 10, injury: 10, failedDeathCheck: true)
              .value,
          HpCondition.dead);
    });

    test('Near Death upper bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 20, failedDeathCheck: false);
      expect(hp.value, HpCondition.near_death);
      expect(hp.injury, 20);
      expect(hp.textValue, 'Near Death');
      expect(hp.valueIndex, 3);
    });

    test('Near death but with failed ht check', () {
      expect(
          HpConditionEnum(hitPoints: 10, injury: 20, failedDeathCheck: true)
              .value,
          HpCondition.dead);
    });

    test('Dead upper bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 60, failedDeathCheck: false);
      expect(hp.value, HpCondition.dead);
      expect(hp.textValue, 'Dead');
      expect(hp.valueIndex, 4);
    });

    test('Destroyed upper bound', () {
      var hp =
          HpConditionEnum(hitPoints: 10, injury: 110, failedDeathCheck: false);
      expect(hp.value, HpCondition.destroyed);
      expect(hp.textValue, 'Destroyed');
      expect(hp.valueIndex, 5);
    });
  });

  test('Destroyed but with failed ht check', () {
    expect(
        HpConditionEnum(hitPoints: 10, injury: 110, failedDeathCheck: true)
            .value,
        HpCondition.destroyed);
  });

  group('Posture', () {
    test('null', () {
      expect(() => PostureEnum(value: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('defaults', () {
      var p = PostureEnum();
      expect(p.value, Posture.standing);
      expect(p.textValue, "STANDING");
      expect(p.valueIndex, 0);
      expect(p.allValues, [
        'STANDING',
        'SITTING',
        'KNEELING',
        'CRAWLING',
        'LIE PRONE',
        'LIE FACE UP'
      ]);
    });

    group('constructor', () {
      test('standing', () {
        var p = PostureEnum(value: Posture.standing);
        expect(p.value, Posture.standing);
        expect(p.textValue, "STANDING");
        expect(p.valueIndex, 0);
      });

      test('sitting', () {
        var p = PostureEnum(value: Posture.sitting);
        expect(p.value, Posture.sitting);
        expect(p.textValue, "SITTING");
        expect(p.valueIndex, 1);
      });

      test('kneeling', () {
        var p = PostureEnum(value: Posture.kneeling);
        expect(p.value, Posture.kneeling);
        expect(p.textValue, "KNEELING");
        expect(p.valueIndex, 2);
      });

      test('crawling', () {
        var p = PostureEnum(value: Posture.crawling);
        expect(p.value, Posture.crawling);
        expect(p.textValue, "CRAWLING");
        expect(p.valueIndex, 3);
      });

      test('lie prone', () {
        var p = PostureEnum(value: Posture.lie_prone);
        expect(p.value, Posture.lie_prone);
        expect(p.textValue, "LIE PRONE");
        expect(p.valueIndex, 4);
      });

      test('lie face up', () {
        var p = PostureEnum(value: Posture.lie_face_up);
        expect(p.value, Posture.lie_face_up);
        expect(p.textValue, "LIE FACE UP");
        expect(p.valueIndex, 5);
      });
    });

    group('fromJSON', () {
      test('standing', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "standing"}')),
            Posture.standing);
      });

      test('sitting', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "sitting"}')),
            Posture.sitting);
      });

      test('kneeling', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "kneeling"}')),
            Posture.kneeling);
      });

      test('crawling', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "crawling"}')),
            Posture.crawling);
      });

      test('lie prone', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "lie_prone"}')),
            Posture.lie_prone);
      });

      test('lie face up', () {
        expect(PostureEnum.fromJSON(json.decode('{"posture": "lie_face_up"}')),
            Posture.lie_face_up);
      });
    });
  });

  group('Maneuver', () {
    test('null', () {
      expect(() => ManeuverEnum(value: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('defaults', () {
      var m = ManeuverEnum();
      expect(m.value, Maneuver.do_nothing);
      expect(m.textValue, "Do Nothing");
      expect(m.valueIndex, 0);
      expect(m.allValues, [
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
      ]);
    });
    group('constructors', () {
      test('move', () {
        var m = ManeuverEnum(value: Maneuver.move);
        expect(m.value, Maneuver.move);
        expect(m.textValue, 'Move');
        expect(m.valueIndex, 1);
      });

      test('change posture', () {
        var m = ManeuverEnum(value: Maneuver.change_posture);
        expect(m.value, Maneuver.change_posture);
        expect(m.textValue, 'Change Posture');
        expect(m.valueIndex, 2);
      });

      test('aim', () {
        var m = ManeuverEnum(value: Maneuver.aim);
        expect(m.value, Maneuver.aim);
        expect(m.textValue, 'Aim');
        expect(m.valueIndex, 3);
      });

      test('attack', () {
        var m = ManeuverEnum(value: Maneuver.attack);
        expect(m.value, Maneuver.attack);
        expect(m.textValue, 'Attack');
        expect(m.valueIndex, 4);
      });

      test('feint', () {
        var m = ManeuverEnum(value: Maneuver.feint);
        expect(m.value, Maneuver.feint);
        expect(m.textValue, 'Feint');
        expect(m.valueIndex, 5);
      });

      test('all-out attack', () {
        var m = ManeuverEnum(value: Maneuver.all_out_attack);
        expect(m.value, Maneuver.all_out_attack);
        expect(m.textValue, 'All-Out Attack');
        expect(m.valueIndex, 6);
      });

      test('move and attack', () {
        var m = ManeuverEnum(value: Maneuver.move_and_attack);
        expect(m.value, Maneuver.move_and_attack);
        expect(m.textValue, 'Move and Attack');
        expect(m.valueIndex, 7);
      });

      test('all-out defense', () {
        var m = ManeuverEnum(value: Maneuver.all_out_defense);
        expect(m.value, Maneuver.all_out_defense);
        expect(m.textValue, 'All-Out Defense');
        expect(m.valueIndex, 8);
      });

      test('concentrate', () {
        var m = ManeuverEnum(value: Maneuver.concentrate);
        expect(m.value, Maneuver.concentrate);
        expect(m.textValue, 'Concentrate');
        expect(m.valueIndex, 9);
      });

      test('ready', () {
        var m = ManeuverEnum(value: Maneuver.ready);
        expect(m.value, Maneuver.ready);
        expect(m.textValue, 'Ready');
        expect(m.valueIndex, 10);
      });

      test('wait', () {
        var m = ManeuverEnum(value: Maneuver.wait);
        expect(m.value, Maneuver.wait);
        expect(m.textValue, 'Wait');
        expect(m.valueIndex, 11);
      });
    });

    group('fromJSON', () {
      test('do nothing', () {
        expect(
            ManeuverEnum.fromJSON(json.decode('{ "maneuver": "do_nothing"  }')),
            Maneuver.do_nothing);
      });

      test('move', () {
        expect(ManeuverEnum.fromJSON(json.decode(' { "maneuver": "move"  }')),
            Maneuver.move);
      });

      test('change posture', () {
        expect(
            ManeuverEnum.fromJSON(
                json.decode('{ "maneuver": "change_posture" }')),
            Maneuver.change_posture);
      });

      test('aim', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"aim"}')),
            Maneuver.aim);
      });

      test('attack', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"attack"}')),
            Maneuver.attack);
      });

      test('feint', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"feint"}')),
            Maneuver.feint);
      });

      test('all-out attack', () {
        expect(
            ManeuverEnum.fromJSON(json.decode('{"maneuver":"all_out_attack"}')),
            Maneuver.all_out_attack);
      });

      test('move and attack', () {
        expect(
            ManeuverEnum.fromJSON(
                json.decode('{"maneuver":"move_and_attack"}')),
            Maneuver.move_and_attack);
      });

      test('all-out defense', () {
        expect(
            ManeuverEnum.fromJSON(
                json.decode('{"maneuver":"all_out_defense"}')),
            Maneuver.all_out_defense);
      });

      test('concentrate', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"concentrate"}')),
            Maneuver.concentrate);
      });

      test('ready', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"ready"}')),
            Maneuver.ready);
      });

      test('wait', () {
        expect(ManeuverEnum.fromJSON(json.decode('{"maneuver":"wait"}')),
            Maneuver.wait);
      });
    });
  });

  group('Condition', () {
    test('null fatigue', () {
      expect(() => Condition(fatigue: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null injury', () {
      expect(() => Condition(injury: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null maneuver', () {
      expect(() => Condition(maneuver: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null posture', () {
      expect(() => Condition(posture: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null failedDeathCheck', () {
      expect(() => Condition(failedDeathCheck: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null stunned', () {
      expect(() => Condition(stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructor defaults', () {
      var c = Condition();

      expect(c.fatigue, 0);
      expect(c.injury, 0);
      expect(c.maneuver, Maneuver.do_nothing);
      expect(c.posture, Posture.standing);
      expect(c.stunned, false);
      expect(c.failedDeathCheck, false);
    });

    test('constructors', () {
      var c = Condition(
          fatigue: 10,
          injury: 18,
          maneuver: Maneuver.move_and_attack,
          posture: Posture.crawling,
          failedDeathCheck: true,
          stunned: true);

      expect(c.fatigue, 10);
      expect(c.injury, 18);
      expect(c.maneuver, Maneuver.move_and_attack);
      expect(c.posture, Posture.crawling);
      expect(c.failedDeathCheck, true);
      expect(c.stunned, true);
    });

    test('fromJSON', () {
      var text = '''
        {
          "stunned": true,
          "fatigue": 35,
          "injury": 9,
          "failedDeathCheck": true,
          "maneuver": "do_nothing",
          "posture": "kneeling"
        }
        ''';

      var c = Condition.fromJSON(json.decode(text));

      expect(c.injury, 9);
      expect(c.maneuver, Maneuver.do_nothing);
      expect(c.posture, Posture.kneeling);
      expect(c.failedDeathCheck, true);
      expect(c.fatigue, 35);
      expect(c.stunned, true);
    });
  });

  var character = Character(
      bio: Bio(name: ''),
      basicAttrs: BasicAttributes(),
      secondaryAttrs: SecondaryAttributes(),
      id: 1);

  group('Combatant', () {
    test('constructor with nulls', () {
      expect(() => Combatant(id: null, character: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructor with null condition', () {
      expect(() => Combatant(id: 1, character: character, condition: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructor', () {
      var c = Combatant(id: 100, character: character);
      expect(c.id, 100);
      expect(c.fpCondition.value, FpCondition.normal);
      expect(c.posture.value, Posture.standing);
      expect(c.maneuver.value, Maneuver.do_nothing);
      expect(c.hpCondition.value, HpCondition.normal);
    });

    test('fromJSON', () {
      var text = '''
      {
        "id": 200,
        "condition": {
          "stunned": true,
          "fatigue": 35,
          "injury": 9,
          "failedDeathCheck": false,
          "maneuver": "aim",
          "posture": "kneeling"
        }
      }''';

      var temp = Combatant.fromJSON(json.decode(text));
      var c = Combatant(
          id: temp.id, condition: temp.condition, character: character);
      expect(c.id, 200);
      expect(c.fpCondition.value, FpCondition.collapse);
      expect(c.hpCondition.value, HpCondition.reeling);
      expect(c.maneuver.value, Maneuver.aim);
      expect(c.posture.value, Posture.kneeling);
    });
  });
}
