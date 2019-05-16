import 'package:flutter/foundation.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:meta/meta.dart';

@immutable
class Melee extends Object {
  final int id;
  final List<Combatant> combatants;
  final List<int> selected;
  final CharacterFactory _factory;

  Melee(
      {@required this.id,
      @required this.combatants,
      this.selected = const <int>[],
      @required CharacterFactory factory})
      : _factory = factory;

  Melee.fromJSON(Map<String, dynamic> json, CharacterFactory factory)
      : this(
            id: json['id'],
            combatants: (json['combatants'] as List<dynamic>)
                .map((item) => Combatant.fromJSON(item, factory))
                .toList(),
            selected: new List<int>.from(json['selected'] as List),
            factory: factory);

  Melee select(int id) {
    if (combatants.map((f) => f.id).contains(id)) {
      if (!selected.contains(id)) {
        var newSelected = [...selected, id];
        return Melee(
            id: this.id,
            combatants: this.combatants,
            selected: newSelected,
            factory: this._factory);
      }
    }
    return this;
  }
}
