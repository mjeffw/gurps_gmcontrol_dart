import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/models/combatant.dart';
import 'dart:convert';

void main() {
  group('FpCondition', () {
    test('all values', () {
      final fp = FpCondition(maxFatiguePoints: 20, fatiguePoints: 7);

      expect(fp.allValues,
          <String>['Normal', 'Very Tired', 'Near Collapse', 'Collapse']);
    });

    test('Normal', () {
      final fp = FpCondition(maxFatiguePoints: 20, fatiguePoints: 20);
      expect(fp.condition, FpConditionValue.normal);
      expect(fp.textValue, 'Normal');
      expect(fp.valueIndex, 0);
    });
    test('Very tired', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 5);
      expect(fp.condition, FpConditionValue.very_tired);
    });
    test('Near collapse', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 0);
      expect(fp.condition, FpConditionValue.near_collapse);
    });
    test('Collapsed', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: -18);
      expect(fp.condition, FpConditionValue.collapse);
    });

    group('fromJSON', () {
      test('normal', () {
        var text = '''
      {
        "maxFP" : 18,
        "FP" : 6
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.maxFatiguePoints, 18);
        expect(fp.fatiguePoints, 6);
        expect(fp.condition, FpConditionValue.normal);
      });

      test('very tired', () {
        var text = '''
      {
        "maxFP" : 18,
        "FP" : 1
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.maxFatiguePoints, 18);
        expect(fp.fatiguePoints, 1);
        expect(fp.condition, FpConditionValue.very_tired);
      });

      test('near collapse', () {
        var text = '''
      {
        "maxFP" : 18,
        "FP" : -17
      }
      ''';

        final fp = FpCondition.fromJSON(json.decode(text));
        expect(fp.maxFatiguePoints, 18);
        expect(fp.fatiguePoints, -17);
        expect(fp.condition, FpConditionValue.near_collapse);
      });
    });
  });

  group('HpCondition', () {
    test('all values', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 10);
      expect(hp.condition, HpConditionValue.normal);
      expect(hp.deathOverride, false);
      expect(hp.hitPoints, 10);
      expect(hp.maxHitPoints, 10);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
      expect(hp.allValues, [
        'Normal',
        'Reeling',
        'Hanging On',
        'Risk Death',
        'Dead',
        'Destroyed'
      ]);
    });

    test('Normal lower bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 4);
      expect(hp.condition, HpConditionValue.normal);
      expect(hp.hitPoints, 4);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
    });

    test('Reeling upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 3);
      expect(hp.condition, HpConditionValue.reeling);
      expect(hp.hitPoints, 3);
      expect(hp.textValue, 'Reeling');
      expect(hp.valueIndex, 1);
    });

    test('Hanging On upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 0);
      expect(hp.condition, HpConditionValue.hanging_on);
      expect(hp.hitPoints, 0);
      expect(hp.textValue, 'Hanging On');
      expect(hp.valueIndex, 2);
    });

    test('Risk Death upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -10);
      expect(hp.condition, HpConditionValue.risking_death);
      expect(hp.hitPoints, -10);
      expect(hp.textValue, 'Risk Death');
      expect(hp.valueIndex, 3);
    });

    test('Dead upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -50);
      expect(hp.condition, HpConditionValue.dead);
      expect(hp.textValue, 'Dead');
      expect(hp.valueIndex, 4);
    });

    test('Destroyed upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -100);
      expect(hp.condition, HpConditionValue.destroyed);
      expect(hp.textValue, 'Destroyed');
      expect(hp.valueIndex, 5);
    });

    group('fromJSON', () {
      test('reeling lower bound', () {
        var text = '''
        {
          "maxHP": 10,
          "HP": 1,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.condition, HpConditionValue.reeling);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, 1);
        expect(hp.deathOverride, false);
      });
      test('hanging on lower bound', () {
        var text = '''
        {
          "maxHP": 10,
          "HP": -9,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.condition, HpConditionValue.hanging_on);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, -9);
        expect(hp.deathOverride, false);
      });
      test('risking death lower bound', () {
        var text = '''
        {
          "maxHP": 10,
          "HP": -49,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.condition, HpConditionValue.risking_death);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, -49);
      });
      test('dead lower bound', () {
        var text = '''
        {
          "maxHP": 10,
          "HP": -99,
          "dead": false
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.condition, HpConditionValue.dead);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, -99);
      });
      test('dead/reeling', () {
        var text = '''
        {
          "maxHP": 10,
          "HP": 1,
          "dead": true
        }
        ''';

        final hp = HpCondition.fromJSON(json.decode(text));
        expect(hp.condition, HpConditionValue.dead);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, 1);
        expect(hp.deathOverride, true);
      });
    });
  });

  group('Maneuver', () {
    test('constructor defaults', () {
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
  });
}
