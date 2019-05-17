import 'dart:convert';

import 'package:gurps_gmcontrol_dart/src/models/character.dart';

class CharacterApi {
  Map<int, Character> _characters = {};

  CharacterApi() {
    Map<String, dynamic> map = json.decode(_characterJson);
    List list = (map['characters'] as List);
    Iterable<Character> iterable =
        list.map((item) => Character.fromJSON(item)).toList();
    iterable.forEach((f) => {_characters[f.id] = f});
  }

  Future<Character> fetch(int id) async {
    return _characters[id];
  }
}

CharacterApi characterApi = CharacterApi();

var _characterJson = '''
{
  "characters":[
    {
      "id": 100,
      "bio": {
        "name": "Grend Gnashtooth"
      },
      "basicAttributes": {
        "ST": 13, "DX": 7, "IQ": 15, "HT": 9
      },
      "secondaryAttributes": {
        "per": 12, "will": 15, "move": 6, "speed": 5.5, "FP": 13, "HP": 14
      }
    }, 
    {
      "id": 101,
      "bio": {
        "name": "Peshkali"
      },
      "basicAttributes": {
        "ST": 20, "DX": 13, "IQ": 11, "HT": 15
      },
      "secondaryAttributes": {
        "per": 12, "will": 15, "move": 6, "speed": 6.75, "FP": 13, "HP": 20
      }
    },
    {
      "id": 102,
      "bio": {
        "name": "Findlay Silvertongue"
      },
      "basicAttributes": {
        "ST": 10, "DX": 12, "IQ": 13, "HT": 10
      },
      "secondaryAttributes": {
        "per": 12, "will": 15, "move": 6, "speed": 6.75, "FP": 13, "HP": 20
      }
    }
  ]
}''';
