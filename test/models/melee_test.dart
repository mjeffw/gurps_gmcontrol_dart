import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';

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
  });
}
