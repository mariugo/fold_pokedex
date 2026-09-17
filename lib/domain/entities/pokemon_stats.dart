import 'package:equatable/equatable.dart';

/// The base battle stats of a Pokémon.
final class PokemonStats extends Equatable {
  /// Creates an immutable set of base battle stats.
  const new({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  /// The base hit points.
  final int hp;

  /// The base attack stat.
  final int attack;

  /// The base defense stat.
  final int defense;

  /// The base special attack stat.
  final int specialAttack;

  /// The base special defense stat.
  final int specialDefense;

  /// The base speed stat.
  final int speed;

  @override
  List<Object?> get props => [
    hp,
    attack,
    defense,
    specialAttack,
    specialDefense,
    speed,
  ];
}
