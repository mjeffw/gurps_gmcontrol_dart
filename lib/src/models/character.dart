import 'package:flutter/foundation.dart';

///
/// The 'personal' information about a character, such as name, race, gender,
/// appearance, religion, etc...
///
/// Although all of this information is optional, it is recommended that the
/// name be provided or else it will look weird in a list.
///
class Bio {
  final String name;

  Bio({this.name});
  Bio.fromJSON(Map<String, dynamic> json) : this(name: json['name'] as String);
}

///
/// Represents the basic attributes of the combatant. Four numbers called
/// attributes define your basic abilities: Strength (ST), Dexterity (DX),
/// Intelligence (IQ), and Health (HT).
///
class BasicAttributes {
  /// Strength (ST) measures physical power and bulk.
  final int st;

  /// Dexterity (DX) is a composite measure of agility, coordination, and fine
  /// motor ability.
  final int dx;

  /// Intelligence (IQ) is a broad measure of brainpower: creativity, cunning,
  /// memory, reason, and so on.
  final int iq;

  /// Health is a measure of energy and vitality.
  final int ht;

  BasicAttributes({this.st = 10, this.dx = 10, this.iq = 10, this.ht = 10})
      : assert(st != null),
        assert(dx != null),
        assert(iq != null),
        assert(ht != null);

  BasicAttributes.fromJSON(json)
      : this(
            st: json['ST'] as int,
            dx: json['DX'] as int,
            iq: json['IQ'] as int,
            ht: json['HT'] as int);
}

class SecondaryAttributes {
  final int move;
  final int per;
  final double speed;
  final int will;
  final int fp;
  final int hp;

  SecondaryAttributes(
      {this.speed = 5.0,
      this.per = 10,
      this.will = 10,
      this.move = 5,
      this.hp = 10,
      this.fp = 10})
      : assert(move != null),
        assert(speed != null),
        assert(will != null),
        assert(per != null),
        assert(hp != null),
        assert(fp != null);

  SecondaryAttributes.fromJSON(Map<String, dynamic> json)
      : this(
            move: json['move'] as int,
            per: json['per'] as int,
            will: json['will'] as int,
            speed: json['speed'] as double,
            hp: json['HP'] as int,
            fp: json['FP'] as int);
}

///
/// Represents a single participant within a Melee.
///
class Character {
  /// This uniquely identifies a Character instance.
  final int id;
  final Bio bio;
  final BasicAttributes basicAttrs;
  final SecondaryAttributes secondaryAttrs;

  Character(
      {@required this.bio,
      @required this.basicAttrs,
      @required this.secondaryAttrs,
      @required this.id})
      : assert(bio != null),
        assert(secondaryAttrs != null),
        assert(basicAttrs != null),
        assert(id != null);

  Character.fromJSON(Map<String, dynamic> json)
      : this(
            id: json['id'] as int,
            bio: Bio.fromJSON(json['bio']),
            basicAttrs: BasicAttributes.fromJSON(json['basicAttributes']),
            secondaryAttrs:
                SecondaryAttributes.fromJSON(json['secondaryAttributes']));
}
