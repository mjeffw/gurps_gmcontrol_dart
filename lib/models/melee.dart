import 'combatant.dart';

class Melee extends Object {
  final int id;
  final List<Combatant> combatants;

  Melee.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        combatants = (json['combatants'] as List<dynamic>)
            .map((item) => Combatant.fromJSON(item))
            .toList() {
    combatants.sort((a, b) => b.speed.compareTo(a.speed));
  }
}
