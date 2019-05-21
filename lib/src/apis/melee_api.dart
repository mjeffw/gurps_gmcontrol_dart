import 'dart:convert';

import 'package:gurps_gmcontrol_dart/src/apis/character_api.dart';
import 'package:gurps_gmcontrol_dart/src/models/character.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:gurps_gmcontrol_dart/src/models/melee.dart';

MeleeApi meleeApi = MeleeApi();

class MeleeApi {
  Future<Melee> fetch({int index}) async {
    // Give some additional delay to simulate slow network
    await Future.delayed(const Duration(seconds: 1));

    var temp = Melee.fromJSON(json.decode(_meleeJsonText));
    var list = await resolveList(temp);

    var melee = Melee(id: temp.id, combatants: list);
    return melee;
  }

  Future<List<Combatant>> resolveList(Melee melee) async {
    var list = <Combatant>[];
    melee.combatants.forEach((it) async {
      Combatant c = await resolveCombatants(it);
      list.add(c);
    });

    return list;
  }

  Future<Combatant> resolveCombatants(Combatant element) async {
    Character c = await characterApi.fetch(element.id);
    Combatant result =
        Combatant(id: element.id, character: c, condition: element.condition);
    return result;
  }
}

var _meleeJsonText = '''
{
  "id" : 0,
  "selected":[],
  "combatants": [
    {
      "id": 100,
      "condition": { 
        "stunned": true, 
        "fatigue" : 9,
        "injury": 15, 
        "failedDeathCheck": false,
        "maneuver": "do_nothing",
        "posture": "crawling"
      }
    },
    {
      "id": 101,
      "condition": { 
        "stunned": false, 
        "fatigue": 23,
        "injury": 3,
        "failedDeathCheck": false,
        "maneuver": "aim",
        "posture": "standing"
      }
    },
    {
      "id": 102,
      "condition": {
        "stunned": false, 
        "fatigue": 24,
        "injury": 1, 
        "failedDeathCheck": false,
        "maneuver": "move_and_attack",
        "posture": "kneeling"
      }
    }
  ]
}
''';
