import 'dart:convert';

import 'package:gurps_gmcontrol_dart/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/models/melee.dart';

class MockCombatant {
  static List<Combatant> fetchAll() {
    var parsedJson = json.decode(text);
    var melee = Melee.fromJSON(parsedJson);
    return melee.combatants;
  }
}

var text = '''
{
  "melee": [
    {
      "name": "Grend Gnashtooth",
      "condition": { "stunned": true, 
        "fpCondition": { "FP" : 12, "fatigue" : 9},
        "hpCondition": { "HP": 15, "injury": 15, "dead": false },
        "maneuver": { "value": "do_nothing"  },
        "posture": { "value": "crawling" }
      },
      "basicAttributes": { "ST": 13, "DX": 7, "IQ": 15, "HT": 9 },
      "secondaryAttributes": { "move": 6, "speed": 6.75, "per": 12, "will": 11}
    },
    {
      "name": "Peshkali",
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : 23},
        "hpCondition": { "HP": 12, "injury": -3, "dead": false },
        "maneuver": { "value": "aim"  },
        "posture": { "value": "standing" }
      },
      "basicAttributes": { "ST": 14, "DX": 9, "IQ": 8, "HT": 13 },
      "secondaryAttributes": { "move": 7, "speed": 7.00, "per": 11, "will": 15}
    },
    {
      "name": "Findlay Silvertongue",
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : -24},
        "hpCondition": { "HP": 12, "injury": 1, "dead": false },
        "maneuver": { "value": "move_and_attack"  },
        "posture": { "value": "kneeling" }
      },
      "basicAttributes": { "ST": 14, "DX": 12, "IQ": 11, "HT": 13 },
      "secondaryAttributes": { "move": 5, "speed": 5.50, "per": 13, "will": 12}
    }
  ]
}
''';
