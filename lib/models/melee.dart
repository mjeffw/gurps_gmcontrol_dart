import 'combatant.dart';

class Melee extends Object {
  List<Combatant> combatants = [];

  Melee.fromJSON(Map<String, dynamic> json)
      : combatants = (json["combatants"] as List<dynamic>)
            .map((item) => Combatant.fromJSON(item))
            .toList();
}
