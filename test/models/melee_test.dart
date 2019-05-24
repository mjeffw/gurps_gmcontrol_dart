import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('melee', () {
    test('constructor, empty state', () {
      var m = Melee(id: 1, combatants: []);
      expect(m.id, 1);
      expect(m.combatants, isEmpty);
    });
    test('constructor, nonempty state', () {
      var m = Melee(
        id: 2,
        combatants: [
          Combatant(id: 100, character: null),
          Combatant(id: 101, character: null),
        ],
      );
      expect(m.id, 2);
      expect(m.combatants, hasLength(2));
    });
    test('fromJSON', () {
      var text = '''
       {
         "id":3,
         "combatants": [
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
           },
           {
            "id": 201,
            "condition": {
              "stunned": false,
              "fatigue": 0,
              "injury": 19,
              "failedDeathCheck": false,
              "maneuver": "move",
              "posture": "lie_prone"
            }
           }
         ],
         "selected": [
           200, 201
         ]
       }
       ''';

      var m = Melee.fromJSON(json.decode(text));
      expect(m.id, 3);
      expect(m.combatants.map((f) => f.id), containsAll([200, 201]));
    });

    group('sort', () {
      var a = Combatant(
          id: 1,
          character: Character(
              bio: Bio(name: 'A'),
              basicAttrs: BasicAttributes(),
              secondaryAttrs: SecondaryAttributes(),
              id: 1));
      var b = Combatant(
          id: 2,
          character: Character(
              bio: Bio(name: 'B'),
              basicAttrs: BasicAttributes(),
              secondaryAttrs: SecondaryAttributes(),
              id: 2));

      a.character.secondaryAttrs.speed = 5.00;
      b.character.secondaryAttrs.speed = 5.00;
      a.character.basicAttrs.dx = 10;
      b.character.basicAttrs.dx = 10;

      test('sort by speed', () {
        a.character.secondaryAttrs.speed = 5.00;
        b.character.secondaryAttrs.speed = 5.25;
        a.character.basicAttrs.dx = 10;
        b.character.basicAttrs.dx = 10;
        var melee = Melee(id: 0, combatants: [a, b]);
        expect(melee.combatants, containsAllInOrder([a, b]));
        melee.sort();
        expect(melee.combatants, containsAllInOrder([b, a]));
      });

      test('sort by dx', () {
        a.character.secondaryAttrs.speed = 5.00;
        b.character.secondaryAttrs.speed = 5.00;
        a.character.basicAttrs.dx = 11;
        b.character.basicAttrs.dx = 12;
        var melee = Melee(id: 0, combatants: [a, b]);
        expect(melee.combatants, containsAllInOrder([a, b]));
        melee.sort();
        expect(melee.combatants, containsAllInOrder([b, a]));
      });

      test('sort randomly', () {
        a.character.secondaryAttrs.speed = 5.00;
        b.character.secondaryAttrs.speed = 5.00;
        a.character.basicAttrs.dx = 10;
        b.character.basicAttrs.dx = 10;
        var melee = Melee(id: 0, combatants: [a, b]);
        expect(melee.combatants, containsAllInOrder([a, b]));

        var mock = MockRandom();
        var values = [10, 11];
        when(mock.nextInt(1000)).thenAnswer((_) => values.removeLast());
        melee.random = mock;

        melee.sort();
        expect(melee.combatants, containsAllInOrder([b, a]));
      });
    });
  });
}

class MockRandom extends Mock implements Random {}
