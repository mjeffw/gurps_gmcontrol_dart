import 'package:gurps_gmcontrol_dart/models/melee.dart';
import 'dart:convert';

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
      "name": "Grend Gnashtooth",
      "speed": 6.75,
      "condition": { "stunned": true, 
        "fpCondition": { "maxFP" : 12, "FP" : 3},
        "hpCondition": { "maxHP": 15, "HP": 15, "dead": false },
        "maneuver": { "value": "do_nothing"  },
        "posture": { "value": "crawling" }
      },
      "primaryAttributes": { "ST": 13, "DX": 7, "IQ": 15, "HT": 9 }
    },
    {
      "name": "Peshkali",
      "speed": 7.0,
      "condition": { "stunned": false, 
        "fpCondition": { "maxFP" : 12, "FP" : -11},
        "hpCondition": { "maxHP": 12, "HP": -3, "dead": false },
        "maneuver": { "value": "aim"  },
        "posture": { "value": "standing" }
      },
      "primaryAttributes": { "ST": 14, "DX": 9, "IQ": 8, "HT": 13 }
    },
    {
      "name": "Findlay Silvertongue",
      "speed": 5.5,
      "condition": { "stunned": false, 
        "fpCondition": { "maxFP" : 12, "FP" : -12},
        "hpCondition": { "maxHP": 12, "HP": 1, "dead": false },
        "maneuver": { "value": "move_and_attack"  },
        "posture": { "value": "kneeling" }
      },
      "primaryAttributes": { "ST": 14, "DX": 12, "IQ": 11, "HT": 13 }
    }
  ]
}
''';
