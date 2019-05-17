import 'dart:convert';

import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';

class MockCombatant {
  static CharacterFactory factory = (int index) {
    if (characters == null) {
      characters = {};
      var parsedJson = json.decode(characterText);
      (parsedJson['characters'] as List<dynamic>)
          .map((item) => Character.fromJSON(item))
          .forEach((f) => characters[f.id] = f);
    }
    return characters[index];
  };

  static Map<int, Character> characters;

  static List<Combatant> fetchAll() {
    var parsedJson = json.decode(combatText);
    var melee = Melee.fromJSON(parsedJson);
    return melee.combatants;
  }
}

var combatText = '''
{
  "melee": [
    {
      "id" : 1,
      "combatants": [
        {
          "characterId": 1,
          "condition": {
            "stunned": true,
            "fatigue": 9,
            "injury": 15,
            "dead": false,
            "maneuver": { "value": "do_nothing"  },
            "posture": { "value", "crawling" }
          }
        },
        {
          "characterId": 2,
          "condition": {
            "stunned": false,
            "fatigue": 23,
            "injury": 0,
            "dead": false,
            "maneuver": { "value": "aim"  },
            "posture": { "value", "standing" }
          }
        },
        {
          "characterId": 3,
          "condition": {
            "stunned": false,
            "fatigue": 24,
            "injury": 1,
            "dead": false,
            "maneuver": { "value": "move_and_attack"  },
            "posture": { "value", "kneeling" }
          }
        }
      ]
    }
  ]
}
''';

var characterText = '''
{
    {
      "id": 1,
      "bio": {"name": "Grend Gnashtooth"},
      "basicAttributes": { "ST": 13, "DX": 7, "IQ": 15, "HT": 9 },
      "secondaryAttributes": { 
        "move": 6, 
        "speed": 6.75, 
        "per": 12, 
        "will": 11,
        "hp": 15,
        "fp": 12
      }
    },
    {
      "id": 2,
      "bio": {"name": "Peshkali"},
      "basicAttributes": { "ST": 14, "DX": 9, "IQ": 8, "HT": 13 },
      "secondaryAttributes": { 
        "move": 7, 
        "speed": 7.00, 
        "per": 11, 
        "will": 15,
        "hp": 12,
        "fp": 12
      }
    },
    {
      "bio": { "name": "Findlay Silvertongue"},
      "basicAttributes": { "ST": 14, "DX": 12, "IQ": 11, "HT": 13 },
      "secondaryAttributes": { 
        "move": 5, "speed": 5.50, "per": 13, "will": 12,
        "fp": 12,
        "hp": 12
        }
    }
  ]
}
''';
