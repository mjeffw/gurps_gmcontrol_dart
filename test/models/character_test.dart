import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:matcher/matcher.dart';

void main() {
  group('Bio', () {
    test('name is optional', () {
      var c = Bio();
      expect(c.name, isNull);
    });
    test('name provided', () {
      var c = Bio(name: 'bo');
      expect(c.name, 'bo');
    });

    test('fromJSON', () {
      var text = '{ "name": "Jackson" }';
      var c = Bio.fromJSON(json.decode(text));
      expect(c.name, 'Jackson');
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
  group('SecondaryAttriubutes', () {
    test('null move', () {
      expect(() => SecondaryAttributes(move: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null speed', () {
      expect(() => SecondaryAttributes(speed: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null will', () {
      expect(() => SecondaryAttributes(will: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null per', () {
      expect(() => SecondaryAttributes(per: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null fp', () {
      expect(() => SecondaryAttributes(fp: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null hp', () {
      expect(() => SecondaryAttributes(hp: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('fromJSON', () {
      var text =
          '{"move": 7, "per": 11, "will":12, "speed": 7.25, "FP": 13, "HP": 14 }';
      var c = SecondaryAttributes.fromJSON(json.decode(text));
      expect(c.move, 7);
      expect(c.per, 11);
      expect(c.will, 12);
      expect(c.speed, 7.25);
      expect(c.fp, 13);
      expect(c.hp, 14);
    });
  });

  group('Character', () {
    test('null name', () {
      expect(
          () => Character(
              bio: null, basicAttrs: null, secondaryAttrs: null, id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null condition', () {
      expect(
          () => Character(
              bio: Bio(name: 'Foo'),
              basicAttrs: null,
              secondaryAttrs: null,
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null secondary', () {
      expect(
          () => Character(
              bio: Bio(name: 'Foo'),
              basicAttrs: null,
              secondaryAttrs: null,
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null id', () {
      expect(
          () => Character(
              bio: Bio(name: 'Foo'),
              basicAttrs: BasicAttributes(),
              secondaryAttrs:
                  SecondaryAttributes(per: 10, speed: 5.0, move: 5, will: 10),
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('null basic', () {
      expect(
          () => Character(
              bio: Bio(name: 'Foo'),
              basicAttrs: null,
              secondaryAttrs:
                  SecondaryAttributes(per: 10, speed: 5.0, move: 5, will: 10),
              id: null),
          throwsA(const TypeMatcher<AssertionError>()));
    });

    test('constructor', () {
      var c = Character(
        id: 1,
        bio: Bio(name: 'Grend'),
        basicAttrs: BasicAttributes(dx: 11, iq: 12, ht: 13),
        secondaryAttrs: SecondaryAttributes(
            move: 6, per: 12, will: 15, speed: 5.5, fp: 14, hp: 13),
      );

      expect(c.basicAttrs.st, 10);
      expect(c.basicAttrs.dx, 11);
      expect(c.basicAttrs.iq, 12);
      expect(c.basicAttrs.ht, 13);
      expect(c.secondaryAttrs.move, 6);
      expect(c.secondaryAttrs.speed, 5.5);
      expect(c.secondaryAttrs.per, 12);
      expect(c.secondaryAttrs.will, 15);
      expect(c.secondaryAttrs.fp, 14);
      expect(c.secondaryAttrs.hp, 13);
      expect(c.bio.name, 'Grend');
    });

    test('fromJSON', () {
      var text = '''
      {
        "id": 1,
        "bio": {
          "name": "Bobbie"
        },
        "condition": {
          "stunned": true,
          "fatigue": 35,
          "injury": 9,
          "failedDeathCheck": false,
          "maneuver": "do_nothing",
          "posture": "kneeling"
        },
        "basicAttributes": {
          "ST": 13, "DX": 7, "IQ": 15, "HT": 9
        },
        "secondaryAttributes": {
          "per": 12, "will": 15, "move": 6, "speed": 5.5, "FP": 13, "HP": 14
        }
      }
      ''';

      var c = Character.fromJSON(json.decode(text));
      expect(c.basicAttrs.st, 13);
      expect(c.basicAttrs.dx, 7);
      expect(c.basicAttrs.iq, 15);
      expect(c.basicAttrs.ht, 9);

      expect(c.secondaryAttrs.move, 6);
      expect(c.secondaryAttrs.speed, 5.5);
      expect(c.secondaryAttrs.per, 12);
      expect(c.secondaryAttrs.will, 15);
      expect(c.secondaryAttrs.fp, 13);
      expect(c.secondaryAttrs.hp, 14);

      expect(c.bio.name, 'Bobbie');
    });
  });
}
