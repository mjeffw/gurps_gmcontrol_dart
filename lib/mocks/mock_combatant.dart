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
      "speed": 6.75,
      "condition": { "stunned": true, 
        "fpCondition": { "FP" : 12, "fatigue" : 9},
        "hpCondition": { "HP": 15, "injury": 15, "dead": false },
        "maneuver": { "value": "do_nothing"  },
        "posture": { "value": "crawling" }
      },
      "basicAttributes": { "ST": 13, "DX": 7, "IQ": 15, "HT": 9 }
    },
    {
      "name": "Peshkali",
      "speed": 7.0,
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : 23},
        "hpCondition": { "HP": 12, "injury": -3, "dead": false },
        "maneuver": { "value": "aim"  },
        "posture": { "value": "standing" }
      },
      "basicAttributes": { "ST": 14, "DX": 9, "IQ": 8, "HT": 13 }
    },
    {
      "name": "Findlay Silvertongue",
      "speed": 5.5,
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : -24},
        "hpCondition": { "HP": 12, "injury": 1, "dead": false },
        "maneuver": { "value": "move_and_attack"  },
        "posture": { "value": "kneeling" }
      },
      "basicAttributes": { "ST": 14, "DX": 12, "IQ": 11, "HT": 13 }
    }
  ]
}
''';
