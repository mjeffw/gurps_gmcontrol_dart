import 'combatant.dart';

class Melee extends Object {
  final int id;
  final List<Combatant> combatants;
  final List<Combatant> selected = <Combatant>[];

  Melee.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        combatants = (json['combatants'] as List<dynamic>)
            .map((item) => Combatant.fromJSON(item))
            .toList() {
    combatants.sort((a, b) => b.speed.compareTo(a.speed));
  }

  bool select(int id) {
    Combatant c = combatants.firstWhere((c) => c.id == id);
    if (c == null) {
      return false;
    }
    if (selected.contains(c)) {
      selected.remove(c);
    } else {
      selected.add(c);
    }
    return true;
  }
}
