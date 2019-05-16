import 'package:flutter/foundation.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:meta/meta.dart';

@immutable
class Melee extends Object {
  static List<Combatant> readCombatantsFromJSON(Map<String, dynamic> json) {
    return (json['combatants'] as List<dynamic>)
        .map((item) => Combatant.fromJSON(item))
        .toList();
  }

  final int id;
  final List<Combatant> combatants;
  final List<int> selected;

  Melee(
      {@required this.id,
      @required this.combatants,
      this.selected = const <int>[]});

  Melee.fromJSON(Map<String, dynamic> json)
      : this(
            id: json['id'],
            combatants: readCombatantsFromJSON(json),
            selected: new List<int>.from(json['selected'] as List));

  Melee select(int id) {
    if (_combatantIdsContain(id)) {
      if (!selected.contains(id)) {
        var newSelected = [...selected, id];
        return Melee(
          id: this.id,
          combatants: this.combatants,
          selected: newSelected,
        );
      }
    }
    return this;
  }

  bool _combatantIdsContain(int id) => combatants.map((f) => f.id).contains(id);
}
