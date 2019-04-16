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
      "id" : 0,
      "name": "Grend Gnashtooth",
      "speed": 6.75,
      "condition": { "stunned": true, 
        "fpCondition": { "FP" : 12, "fatigue" : 3},
        "hpCondition": { "HP": 15, "injury": 15, "dead": false },
        "maneuver": { "value": "do_nothing"  },
        "posture": { "value": "crawling" }
      },
      "basicAttributes": { "ST": 13, "DX": 7, "IQ": 15, "HT": 9 }
    },
    {
      "id" : 1,
      "name": "Peshkali",
      "speed": 7.0,
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : -11},
        "hpCondition": { "HP": 12, "injury": -3, "dead": false },
        "maneuver": { "value": "aim"  },
        "posture": { "value": "standing" }
      },
      "basicAttributes": { "ST": 14, "DX": 9, "IQ": 8, "HT": 13 }
    },
    {
      "id" : 2,
      "name": "Findlay Silvertongue",
      "speed": 5.5,
      "condition": { "stunned": false, 
        "fpCondition": { "FP" : 12, "fatigue" : -12},
        "hpCondition": { "HP": 12, "injury": 1, "dead": false },
        "maneuver": { "value": "move_and_attack"  },
        "posture": { "value": "kneeling" }
      },
      "basicAttributes": { "ST": 14, "DX": 12, "IQ": 11, "HT": 13 }
    }
  ]
}
''';
