import 'dart:convert';

import 'package:gurps_gmcontrol_dart/src/models/melee.dart';

class MeleeApi {
  Future<Melee> fetch({int index}) async {
    // Give some additional delay to simulate slow network
    await Future.delayed(const Duration(seconds: 1));

    return Melee.fromJSON(json.decode(_text));
  }
}

MeleeApi api = MeleeApi();

var _text = '''
{
  "id" : 0,
  "combatants": [
    {
      "id": 0,
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
      "id": 1,
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
      "id": 2,
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
