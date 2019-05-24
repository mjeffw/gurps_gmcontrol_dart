import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:gurps_gmcontrol_dart/src/models/combatant.dart';
import 'package:meta/meta.dart';

class Melee with ChangeNotifier {
  final int _id;
  final List<Combatant> _combatants;

  ///
  /// Useful for unit testing
  ///
  Random random = Random();

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

  void sort() {
    _combatants.sort((a, b) => _compare(a, b));
    notifyListeners();
  }

  int _compare(Combatant aa, Combatant bb) {
    var a = aa.character;
    var b = bb.character;

    if (a.secondaryAttrs.speed != b.secondaryAttrs.speed) {
      // invert the comparison -- sorting in reverse numeric order
      return -a.secondaryAttrs.speed.compareTo(b.secondaryAttrs.speed);
    }

    if (a.basicAttrs.dx != b.basicAttrs.dx) {
      // invert the comparison -- sorting in reverse numeric order
      return -a.basicAttrs.dx.compareTo(b.basicAttrs.dx);
    }

    return random.nextInt(1000).compareTo(random.nextInt(1000));
  }
}
