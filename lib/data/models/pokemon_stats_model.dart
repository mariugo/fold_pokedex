import 'package:fold_pokedex/domain/entities/pokemon_stats.dart';

/// Raw `stats` list shape from the PokeAPI `pokemon/{id}` endpoint.
///
/// Stats are looked up by name instead of list index, since the API does not
/// guarantee ordering.
final class PokemonStatsModel {
  /// Creates a model from already-extracted stat values.
  const new({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  /// Parses the `stats` array of a PokeAPI Pokémon response.
  factory fromJson(List<dynamic> stats) {
    final entries = stats.cast<Map<String, dynamic>>();

    int statByName(String name) {
      final match = entries.firstWhere(
        (entry) => (entry['stat'] as Map<String, dynamic>)['name'] == name,
        orElse: () => const {'base_stat': 0},
      );
      return match['base_stat'] as int;
    }

    return PokemonStatsModel(
      hp: statByName('hp'),
      attack: statByName('attack'),
      defense: statByName('defense'),
      specialAttack: statByName('special-attack'),
      specialDefense: statByName('special-defense'),
      speed: statByName('speed'),
    );
  }

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

  /// Converts this model into the clean [PokemonStats] domain model.
  PokemonStats toDomain() {
    return PokemonStats(
      hp: hp,
      attack: attack,
      defense: defense,
      specialAttack: specialAttack,
      specialDefense: specialDefense,
      speed: speed,
    );
  }
}
