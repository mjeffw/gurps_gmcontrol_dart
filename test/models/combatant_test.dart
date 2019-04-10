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
      expect(fp.value, FpConditionValue.normal);
      expect(fp.textValue, 'Normal');
      expect(fp.valueIndex, 0);
    });
    test('Very tired', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 5);
      expect(fp.value, FpConditionValue.very_tired);
    });
    test('Near collapse', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: 0);
      expect(fp.value, FpConditionValue.near_collapse);
    });
    test('Collapsed', () {
      final fp = FpCondition(maxFatiguePoints: 18, fatiguePoints: -18);
      expect(fp.value, FpConditionValue.collapse);
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
        expect(fp.value, FpConditionValue.normal);
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
        expect(fp.value, FpConditionValue.very_tired);
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
        expect(fp.value, FpConditionValue.near_collapse);
      });
    });
  });

  group('HpCondition', () {
    test('all values', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 10);
      expect(hp.value, HpConditionValue.normal);
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
      expect(hp.value, HpConditionValue.normal);
      expect(hp.hitPoints, 4);
      expect(hp.textValue, 'Normal');
      expect(hp.valueIndex, 0);
    });

    test('Reeling upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 3);
      expect(hp.value, HpConditionValue.reeling);
      expect(hp.hitPoints, 3);
      expect(hp.textValue, 'Reeling');
      expect(hp.valueIndex, 1);
    });

    test('Hanging On upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: 0);
      expect(hp.value, HpConditionValue.hanging_on);
      expect(hp.hitPoints, 0);
      expect(hp.textValue, 'Hanging On');
      expect(hp.valueIndex, 2);
    });

    test('Risk Death upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -10);
      expect(hp.value, HpConditionValue.risking_death);
      expect(hp.hitPoints, -10);
      expect(hp.textValue, 'Risk Death');
      expect(hp.valueIndex, 3);
    });

    test('Dead upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -50);
      expect(hp.value, HpConditionValue.dead);
      expect(hp.textValue, 'Dead');
      expect(hp.valueIndex, 4);
    });

    test('Destroyed upper bound', () {
      var hp = HpCondition(maxHitPoints: 10, hitPoints: -100);
      expect(hp.value, HpConditionValue.destroyed);
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
        expect(hp.value, HpConditionValue.reeling);
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
        expect(hp.value, HpConditionValue.hanging_on);
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
        expect(hp.value, HpConditionValue.risking_death);
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
        expect(hp.value, HpConditionValue.dead);
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
        expect(hp.value, HpConditionValue.dead);
        expect(hp.maxHitPoints, 10);
        expect(hp.hitPoints, 1);
        expect(hp.deathOverride, true);
      });
    });
  });

  group('Maneuver', () {
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

  group('PrimaryAttributes', () {
    test('defaults', () {
      var p = PrimaryAttributes();
      expect(p.st, 10);
      expect(p.iq, 10);
      expect(p.dx, 10);
      expect(p.ht, 10);
    });

    group('constructors', () {
      test('st', () {
        var p = PrimaryAttributes(st: 8);
        expect(p.st, 8);
        expect(p.iq, 10);
        expect(p.dx, 10);
        expect(p.ht, 10);
      });

      test('dx', () {
        var p = PrimaryAttributes(dx: 8);
        expect(p.st, 10);
        expect(p.iq, 10);
        expect(p.dx, 8);
        expect(p.ht, 10);
      });

      test('iq', () {
        var p = PrimaryAttributes(iq: 8);
        expect(p.st, 10);
        expect(p.iq, 8);
        expect(p.dx, 10);
        expect(p.ht, 10);
      });

      test('ht', () {
        var p = PrimaryAttributes(ht: 8);
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
        var p = PrimaryAttributes.fromJSON(json.decode(text));
        expect(p.st, 13);
        expect(p.iq, 15);
        expect(p.dx, 7);
        expect(p.ht, 9);
      });
    });
  });

  group('Condition', () {
    test('constructors', () {
      var c = Condition(
          fpCondition: FpCondition(maxFatiguePoints: 12, fatiguePoints: 2),
          hpCondition: HpCondition(maxHitPoints: 15, hitPoints: -3),
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
          "maxFP" : 18,
          "FP" : -17
        },
        "hpCondition" : {
          "maxHP": 10,
          "HP": 1,
          "dead": true
        },
        "maneuver": { "value": "do_nothing"  },
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
    test('constructor', () {
      var c = Combatant(
        condition: Condition(
            fpCondition: FpCondition(maxFatiguePoints: 12, fatiguePoints: 2),
            hpCondition: HpCondition(maxHitPoints: 15, hitPoints: -3),
            maneuver: Maneuver(value: ManeuverValue.move_and_attack),
            posture: Posture(value: PostureValue.crawling),
            stunned: false),
        name: 'Grend',
        primaryAttrs: PrimaryAttributes(dx: 11, iq: 12, ht: 13),
        speed: 5.5,
      );

      expect(c.condition.fpCondition.value, FpConditionValue.very_tired);
      expect(c.condition.hpCondition.value, HpConditionValue.hanging_on);
      expect(c.condition.maneuver.value, ManeuverValue.move_and_attack);
      expect(c.condition.posture.value, PostureValue.crawling);
      expect(c.condition.stunned, false);
      expect(c.primaryAttrs.st, 10);
      expect(c.primaryAttrs.dx, 11);
      expect(c.primaryAttrs.iq, 12);
      expect(c.primaryAttrs.ht, 13);
      expect(c.name, 'Grend');
      expect(c.speed, 5.5);
    });

    test('fromJSON', () {
      var text = '''
      {
        "name": "Bobbie",
        "speed": 6.75,
        "condition": {
          "stunned": true,
          "fpCondition": {
            "maxFP" : 18,
            "FP" : -17
          },
          "hpCondition" : {
            "maxHP": 10,
            "HP": 1,
            "dead": false
          },
          "maneuver": { "value": "do_nothing"  },
          "posture": { "value": "kneeling" }
        },
        "primaryAttributes": {
          "ST": 13, "DX": 7, "IQ": 15, "HT": 9
        }
      }
      ''';

      var c = Combatant.fromJSON(json.decode(text));
      expect(c.condition.fpCondition.value, FpConditionValue.near_collapse);
      expect(c.condition.hpCondition.value, HpConditionValue.reeling);
      expect(c.condition.maneuver.value, ManeuverValue.do_nothing);
      expect(c.condition.posture.value, PostureValue.kneeling);
      expect(c.condition.stunned, true);
      expect(c.primaryAttrs.st, 13);
      expect(c.primaryAttrs.dx, 7);
      expect(c.primaryAttrs.iq, 15);
      expect(c.primaryAttrs.ht, 9);
      expect(c.name, 'Bobbie');
      expect(c.speed, 6.75);
    });
  });
}
