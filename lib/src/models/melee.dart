import 'package:flutter/foundation.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:meta/meta.dart';

class Melee with ChangeNotifier {
  final int _id;
  final List<Combatant> _combatants;

  Melee({@required int id, @required List<Combatant> combatants})
      : this._id = id,
        this._combatants = combatants;

  Melee.fromJSON(Map<String, dynamic> json)
      : this(id: json['id'], combatants: readCombatantsFromJSON(json));

  int get id => _id;
  List<Combatant> get combatants => List.unmodifiable(_combatants);

  static List<Combatant> readCombatantsFromJSON(Map<String, dynamic> json) {
    return (json['combatants'] as List<dynamic>)
        .map((item) => Combatant.fromJSON(item))
        .toList();
  }
}
