import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('FpCondition', () {
    test('null fatigueLoss', () {
      expect(() => FpCondition(fatigueLoss: null, fatiguePoints: 10),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null fatiguePoints', () {
      expect(() => FpCondition(fatigueLoss: 10, fatiguePoints: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('all values', () {
      final fp = FpCondition(fatiguePoints: 20, fatigueLoss: 7);

      expect(fp.allValues,
          <String>['Normal', 'Very Tired', 'Near Collapse', 'Collapse']);
    });

    test('Normal', () {
      final fp = FpCondition(fatiguePoints: 20, fatigueLoss: 0);
      expect(fp.value, FpConditionValue.normal);
      expect(fp.textValue, 'Normal');
      expect(fp.valueIndex, 0);
    });
    test('Very tired', () {
      final fp = FpCondition(fatiguePoints: 18, fatigueLoss: 13);
      expect(fp.value, FpConditionValue.very_tired);
    });
    test('Near collapse', () {
      final fp = FpCondition(fatiguePoints: 18, fatigueLoss: 18);
      expect(fp.value, FpConditionValue.near_collapse);
    });
    test('Collapsed', () {
      final fp = FpCondition(fatiguePoints: 18, fatigueLoss: 36);
      expect(fp.value, FpConditionValue.collapse);
    });

    group('fromJSON', () {
      test('normal', () {
        var text = '''
      {
        "FP" : 18,
        "fatigue" : 6
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.fatiguePoints, 18);
        expect(fp.fatigueLoss, 6);
        expect(fp.value, FpConditionValue.normal);
      });

      test('very tired', () {
        var text = '''
      {
        "FP" : 18,
        "fatigue" : 17
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.fatiguePoints, 18);
        expect(fp.fatigueLoss, 17);
        expect(fp.value, FpConditionValue.very_tired);
      });

      test('near collapse', () {
        var text = '''
      {
        "FP" : 18,
        "fatigue" : 35
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.fatiguePoints, 18);
        expect(fp.fatigueLoss, 35);
        expect(fp.value, FpConditionValue.near_collapse);
      });
    });
  });

  group('HpCondition', () {
    test('null hitPoints', () {
      expect(() => HpCondition(hitPoints: null, injury: 10),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null injury', () {
      expect(() => HpCondition(hitPoints: 10, injury: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('all values', () {
      var hp = HpCondition(hitPoints: 10, injury: 0);
      expect(hp.value, HpConditionValue.normal);
      expect(hp.deathOverride, false);
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
      var hp = HpCondition(hitPoints: 10, injury: 6);
      expect(hp.value, HpConditionValue.normal);
      expect(hp.injury, 6);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
    });

    test('Reeling upper bound', () {
      var hp = HpCondition(hitPoints: 10, injury: 7);
      expect(hp.value, HpConditionValue.reeling);
      expect(hp.injury, 7);
      expect(hp.textValue, 'Reeling');
      expect(hp.valueIndex, 1);
    });

    test('Hanging On upper bound', () {
      var hp = HpCondition(hitPoints: 10, injury: 10);
      expect(hp.value, HpConditionValue.hanging_on);
      expect(hp.injury, 10);
      expect(hp.textValue, 'Hanging On');
      expect(hp.valueIndex, 2);
    });

    test('Near Death upper bound', () {
      var hp = HpCondition(hitPoints: 10, injury: 20);
      expect(hp.value, HpConditionValue.near_death);
      expect(hp.injury, 20);
      expect(hp.textValue, 'Near Death');
      expect(hp.valueIndex, 3);
    });

    test('Dead upper bound', () {
      var hp = HpCondition(hitPoints: 10, injury: 60);
      expect(hp.value, HpConditionValue.dead);
      expect(hp.textValue, 'Dead');
      expect(hp.valueIndex, 4);
    });

    test('Destroyed upper bound', () {
      var hp = HpCondition(hitPoints: 10, injury: 110);
      expect(hp.value, HpConditionValue.destroyed);
      expect(hp.textValue, 'Destroyed');
      expect(hp.valueIndex, 5);
    });

    group('fromJSON', () {
      test('reeling lower bound', () {
        var text = '''
        {
          "HP": 10,
          "injury": 9,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.value, HpConditionValue.reeling);
        expect(hp.hitPoints, 10);
        expect(hp.injury, 9);
        expect(hp.deathOverride, false);
      });
      test('hanging on lower bound', () {
        var text = '''
        {
          "HP": 10,
          "injury": 19,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.value, HpConditionValue.hanging_on);
        expect(hp.hitPoints, 10);
        expect(hp.injury, 19);
        expect(hp.deathOverride, false);
      });
      test('risking death lower bound', () {
        var text = '''
        {
          "HP": 10,
          "injury": 59,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.value, HpConditionValue.near_death);
        expect(hp.hitPoints, 10);
        expect(hp.injury, 59);
      });
      test('dead lower bound', () {
        var text = '''
        {
          "HP": 10,
          "injury": 109,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.value, HpConditionValue.dead);
        expect(hp.hitPoints, 10);
        expect(hp.injury, 109);
      });
      test('dead/reeling', () {
        var text = '''
        {
          "HP": 10,
          "injury": 9,
          "dead": true
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.value, HpConditionValue.dead);
        expect(hp.hitPoints, 10);
        expect(hp.injury, 9);
        expect(hp.deathOverride, true);
      });
    });
  });

  group('Maneuver', () {
    test('null', () {
      expect(() => Maneuver(value: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('defaults', () {
      var m = Maneuver();
      expect(m.value, ManeuverValue.do_nothing);
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
        var m = Maneuver(value: ManeuverValue.move);
        expect(m.value, ManeuverValue.move);
        expect(m.textValue, 'Move');
        expect(m.valueIndex, 1);
      });

      test('change posture', () {
        var m = Maneuver(value: ManeuverValue.change_posture);
        expect(m.value, ManeuverValue.change_posture);
        expect(m.textValue, 'Change Posture');
        expect(m.valueIndex, 2);
      });

      test('aim', () {
        var m = Maneuver(value: ManeuverValue.aim);
        expect(m.value, ManeuverValue.aim);
        expect(m.textValue, 'Aim');
        expect(m.valueIndex, 3);
      });

      test('attack', () {
        var m = Maneuver(value: ManeuverValue.attack);
        expect(m.value, ManeuverValue.attack);
        expect(m.textValue, 'Attack');
        expect(m.valueIndex, 4);
      });

      test('feint', () {
        var m = Maneuver(value: ManeuverValue.feint);
        expect(m.value, ManeuverValue.feint);
        expect(m.textValue, 'Feint');
        expect(m.valueIndex, 5);
      });

      test('all-out attack', () {
        var m = Maneuver(value: ManeuverValue.all_out_attack);
        expect(m.value, ManeuverValue.all_out_attack);
        expect(m.textValue, 'All-Out Attack');
        expect(m.valueIndex, 6);
      });

      test('move and attack', () {
        var m = Maneuver(value: ManeuverValue.move_and_attack);
        expect(m.value, ManeuverValue.move_and_attack);
        expect(m.textValue, 'Move and Attack');
        expect(m.valueIndex, 7);
      });

      test('all-out defense', () {
        var m = Maneuver(value: ManeuverValue.all_out_defense);
        expect(m.value, ManeuverValue.all_out_defense);
        expect(m.textValue, 'All-Out Defense');
        expect(m.valueIndex, 8);
      });

      test('concentrate', () {
        var m = Maneuver(value: ManeuverValue.concentrate);
        expect(m.value, ManeuverValue.concentrate);
        expect(m.textValue, 'Concentrate');
        expect(m.valueIndex, 9);
      });

      test('ready', () {
        var m = Maneuver(value: ManeuverValue.ready);
        expect(m.value, ManeuverValue.ready);
        expect(m.textValue, 'Ready');
        expect(m.valueIndex, 10);
      });

      test('wait', () {
        var m = Maneuver(value: ManeuverValue.wait);
        expect(m.value, ManeuverValue.wait);
        expect(m.textValue, 'Wait');
        expect(m.valueIndex, 11);
      });
    });

    group('fromJSON', () {
      test('do nothing', () {
        var text = ' { "value": "do_nothing"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.do_nothing);
      });

      test('move', () {
        var text = ' { "value": "move"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.move);
      });

      test('change posture', () {
        var text = ' { "value": "change_posture"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.change_posture);
      });

      test('aim', () {
        var text = ' { "value": "aim"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.aim);
      });

      test('attack', () {
        var text = ' { "value": "attack"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.attack);
      });

      test('feint', () {
        var text = ' { "value": "feint"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.feint);
      });

      test('all-out attack', () {
        var text = ' { "value": "all_out_attack"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.all_out_attack);
      });

      test('move and attack', () {
        var text = ' { "value": "move_and_attack"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.move_and_attack);
      });

      test('all-out defense', () {
        var text = ' { "value": "all_out_defense"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.all_out_defense);
      });

      test('concentrate', () {
        var text = ' { "value": "concentrate"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.concentrate);
      });

      test('ready', () {
        var text = ' { "value": "ready"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.ready);
      });

      test('wait', () {
        var text = ' { "value": "wait"  }';
        var m = Maneuver.fromJSON(json.decode(text));
        expect(m.value, ManeuverValue.wait);
      });
    });
  });

  group('Posture', () {
    test('null', () {
      expect(() => Posture(value: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('defaults', () {
      var p = Posture();
      expect(p.value, PostureValue.standing);
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

    group('construuctor', () {
      test('standing', () {
        var p = Posture(value: PostureValue.standing);
        expect(p.value, PostureValue.standing);
        expect(p.textValue, "STANDING");
        expect(p.valueIndex, 0);
      });

      test('sitting', () {
        var p = Posture(value: PostureValue.sitting);
        expect(p.value, PostureValue.sitting);
        expect(p.textValue, "SITTING");
        expect(p.valueIndex, 1);
      });

      test('kneeling', () {
        var p = Posture(value: PostureValue.kneeling);
        expect(p.value, PostureValue.kneeling);
        expect(p.textValue, "KNEELING");
        expect(p.valueIndex, 2);
      });

      test('crawling', () {
        var p = Posture(value: PostureValue.crawling);
        expect(p.value, PostureValue.crawling);
        expect(p.textValue, "CRAWLING");
        expect(p.valueIndex, 3);
      });

      test('lie prone', () {
        var p = Posture(value: PostureValue.lie_prone);
        expect(p.value, PostureValue.lie_prone);
        expect(p.textValue, "LIE PRONE");
        expect(p.valueIndex, 4);
      });

      test('lie face up', () {
        var p = Posture(value: PostureValue.lie_face_up);
        expect(p.value, PostureValue.lie_face_up);
        expect(p.textValue, "LIE FACE UP");
        expect(p.valueIndex, 5);
      });
    });

    group('fromJSON', () {
      test('standing', () {
        var text = '{ "value": "standing" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.standing);
      });

      test('sitting', () {
        var text = '{ "value": "sitting" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.sitting);
      });

      test('kneeling', () {
        var text = '{ "value": "kneeling" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.kneeling);
      });

      test('crawling', () {
        var text = '{ "value": "crawling" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.crawling);
      });

      test('lie prone', () {
        var text = '{ "value": "lie_prone" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.lie_prone);
      });

      test('lie face up', () {
        var text = '{ "value": "lie_face_up" }';
        var p = Posture.fromJSON(json.decode(text));
        expect(p.value, PostureValue.lie_face_up);
      });
    });
  });

  group('SecondaryAttriubutes', () {
    test('null move', () {
      expect(
          () => SecondaryAttributes(move: null, speed: 5.5, per: 10, will: 10),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null speed', () {
      expect(() => SecondaryAttributes(move: 5, speed: null, per: 10, will: 10),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null will', () {
      expect(
          () => SecondaryAttributes(move: 5, speed: 5.25, per: 10, will: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null per', () {
      expect(
          () => SecondaryAttributes(move: 5, speed: 5.25, per: null, will: 10),
          throwsA(const TypeMatcher<AssertionError>()));
    });
  });

  group('BasicAttributes', () {
    test('null st', () {
      expect(() => BasicAttributes(st: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null dx', () {
      expect(() => BasicAttributes(dx: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null iq', () {
      expect(() => BasicAttributes(iq: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null ht', () {
      expect(() => BasicAttributes(ht: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('defaults', () {
      var p = BasicAttributes();
      expect(p.st, 10);
      expect(p.iq, 10);
      expect(p.dx, 10);
      expect(p.ht, 10);
    });

    group('constructors', () {
      test('st', () {
        var p = BasicAttributes(st: 8);
        expect(p.st, 8);
        expect(p.iq, 10);
        expect(p.dx, 10);
        expect(p.ht, 10);
      });

      test('dx', () {
        var p = BasicAttributes(dx: 8);
        expect(p.st, 10);
        expect(p.iq, 10);
        expect(p.dx, 8);
        expect(p.ht, 10);
      });

      test('iq', () {
        var p = BasicAttributes(iq: 8);
        expect(p.st, 10);
        expect(p.iq, 8);
        expect(p.dx, 10);
        expect(p.ht, 10);
      });

      test('ht', () {
        var p = BasicAttributes(ht: 8);
        expect(p.st, 10);
        expect(p.iq, 10);
        expect(p.dx, 10);
        expect(p.ht, 8);
      });
    });

    group('fromJSON', () {
      test('it', () {
        var text = '''
        {
          "ST": 13,
          "DX": 7,
          "IQ": 15,
          "HT": 9
        }
        ''';
        var p = BasicAttributes.fromJSON(json.decode(text));
        expect(p.st, 13);
        expect(p.iq, 15);
        expect(p.dx, 7);
        expect(p.ht, 9);
      });
    });
  });

  group('Condition', () {
    test('null fpCondition', () {
      expect(
          () => Condition(
              fpCondition: null,
              hpCondition: null,
              maneuver: null,
              posture: null,
              stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null hpCondition', () {
      expect(
          () => Condition(
              fpCondition: FpCondition(fatiguePoints: 10, fatigueLoss: 0),
              hpCondition: null,
              maneuver: null,
              posture: null,
              stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null maneuver', () {
      expect(
          () => Condition(
              fpCondition: FpCondition(fatiguePoints: 10, fatigueLoss: 0),
              hpCondition: HpCondition(injury: 0, hitPoints: 10),
              maneuver: null,
              posture: null,
              stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null posture', () {
      expect(
          () => Condition(
              fpCondition: FpCondition(fatiguePoints: 10, fatigueLoss: 0),
              hpCondition: HpCondition(injury: 0, hitPoints: 10),
              maneuver: Maneuver(value: ManeuverValue.aim),
              posture: null,
              stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null stunned', () {
      expect(
          () => Condition(
              fpCondition: FpCondition(fatiguePoints: 10, fatigueLoss: 0),
              hpCondition: HpCondition(injury: 0, hitPoints: 10),
              maneuver: Maneuver(value: ManeuverValue.aim),
              posture: Posture(value: PostureValue.crawling),
              stunned: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructors', () {
      var c = Condition(
          fpCondition: FpCondition(fatiguePoints: 12, fatigueLoss: 10),
          hpCondition: HpCondition(hitPoints: 15, injury: 18),
          maneuver: Maneuver(value: ManeuverValue.move_and_attack),
          posture: Posture(value: PostureValue.crawling),
          stunned: false);

      expect(c.fpCondition.value, FpConditionValue.very_tired);
      expect(c.hpCondition.value, HpConditionValue.hanging_on);
      expect(c.maneuver.value, ManeuverValue.move_and_attack);
      expect(c.posture.value, PostureValue.crawling);
      expect(c.stunned, false);
    });

    test('fromJSON', () {
      var text = '''
      {
        "stunned": true,
        "fpCondition": {
          "FP": 18,
          "fatigue" : 35
        },
        "hpCondition" : {
          "HP": 10,
          "injury": 9,
          "dead": true
        },
        "maneuver": { "value": "do_nothing" },
        "posture": { "value": "kneeling" }
      }
      ''';

      var c = Condition.fromJSON(json.decode(text));

      expect(c.fpCondition.value, FpConditionValue.near_collapse);
      expect(c.hpCondition.value, HpConditionValue.dead);
      expect(c.maneuver.value, ManeuverValue.do_nothing);
      expect(c.posture.value, PostureValue.kneeling);
      expect(c.stunned, true);
    });
  });
  group('Combatant', () {
    test('null name', () {
      expect(
          () => Combatant(
              name: null,
              condition: null,
              basicAttrs: null,
              secondaryAttrs: null,
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null condition', () {
      expect(
          () => Combatant(
              name: 'Foo',
              condition: null,
              basicAttrs: null,
              secondaryAttrs: null,
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null secondary', () {
      expect(
          () => Combatant(
              name: 'Foo',
              condition: Condition(
                  fpCondition: FpCondition(fatigueLoss: 0, fatiguePoints: 10),
                  hpCondition: HpCondition(hitPoints: 10, injury: 0),
                  stunned: true,
                  posture: Posture(value: PostureValue.kneeling),
                  maneuver: Maneuver(value: ManeuverValue.all_out_defense)),
              basicAttrs: null,
              secondaryAttrs: null,
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null id', () {
      expect(
          () => Combatant(
              name: 'Foo',
              condition: Condition(
                  fpCondition: FpCondition(fatigueLoss: 0, fatiguePoints: 10),
                  hpCondition: HpCondition(hitPoints: 10, injury: 0),
                  stunned: true,
                  posture: Posture(value: PostureValue.kneeling),
                  maneuver: Maneuver(value: ManeuverValue.all_out_defense)),
              basicAttrs: BasicAttributes(),
              secondaryAttrs:
                  SecondaryAttributes(per: 10, speed: 5.0, move: 5, will: 10),
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null basic', () {
      expect(
          () => Combatant(
              name: 'Foo',
              condition: Condition(
                  fpCondition: FpCondition(fatigueLoss: 0, fatiguePoints: 10),
                  hpCondition: HpCondition(hitPoints: 10, injury: 0),
                  stunned: true,
                  posture: Posture(value: PostureValue.kneeling),
                  maneuver: Maneuver(value: ManeuverValue.all_out_defense)),
              basicAttrs: null,
              secondaryAttrs:
                  SecondaryAttributes(per: 10, speed: 5.0, move: 5, will: 10),
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructor', () {
      var c = Combatant(
        id: 1,
        condition: Condition(
            fpCondition: FpCondition(fatiguePoints: 12, fatigueLoss: 10),
            hpCondition: HpCondition(hitPoints: 15, injury: 18),
            maneuver: Maneuver(value: ManeuverValue.move_and_attack),
            posture: Posture(value: PostureValue.crawling),
            stunned: false),
        name: 'Grend',
        basicAttrs: BasicAttributes(dx: 11, iq: 12, ht: 13),
        secondaryAttrs:
            SecondaryAttributes(move: 6, per: 12, will: 15, speed: 5.5),
      );

      expect(c.condition.fpCondition.value, FpConditionValue.very_tired);
      expect(c.condition.hpCondition.value, HpConditionValue.hanging_on);
      expect(c.condition.maneuver.value, ManeuverValue.move_and_attack);
      expect(c.condition.posture.value, PostureValue.crawling);
      expect(c.condition.stunned, false);
      expect(c.basicAttrs.st, 10);
      expect(c.basicAttrs.dx, 11);
      expect(c.basicAttrs.iq, 12);
      expect(c.basicAttrs.ht, 13);
      expect(c.secondaryAttrs.move, 6);
      expect(c.secondaryAttrs.speed, 5.5);
      expect(c.secondaryAttrs.per, 12);
      expect(c.secondaryAttrs.will, 15);
      expect(c.name, 'Grend');
      expect(c.speed, 5.5);
    });

    test('fromJSON', () {
      var text = '''
      {
        "id": 1,
        "name": "Bobbie",
        "condition": {
          "stunned": true,
          "fpCondition": {
            "FP" : 18,
            "fatigue": 35
          },
          "hpCondition": {
            "HP": 10,
            "injury": 9,
            "dead": false
          },
          "maneuver": { "value": "do_nothing"  },
          "posture": { "value": "kneeling" }
        },
        "basicAttributes": {
          "ST": 13, "DX": 7, "IQ": 15, "HT": 9
        },
        "secondaryAttributes": {
          "per": 12, "will": 15, "move": 6, "speed": 5.5
        }
      }
      ''';

      var c = Combatant.fromJSON(json.decode(text));
      expect(c.condition.fpCondition.value, FpConditionValue.near_collapse);
      expect(c.condition.hpCondition.value, HpConditionValue.reeling);
      expect(c.condition.maneuver.value, ManeuverValue.do_nothing);
      expect(c.condition.posture.value, PostureValue.kneeling);
      expect(c.condition.stunned, true);
      expect(c.basicAttrs.st, 13);
      expect(c.basicAttrs.dx, 7);
      expect(c.basicAttrs.iq, 15);
      expect(c.basicAttrs.ht, 9);
      expect(c.secondaryAttrs.move, 6);
      expect(c.secondaryAttrs.speed, 5.5);
      expect(c.secondaryAttrs.per, 12);
      expect(c.secondaryAttrs.will, 15);
      expect(c.name, 'Bobbie');
      expect(c.speed, 5.5);
    });
  });
}
