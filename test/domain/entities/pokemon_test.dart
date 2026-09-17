import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/domain/entities/pokemon.dart';
import 'package:fold_pokedex/domain/entities/pokemon_stats.dart';

void main() {
  group('Pokemon', () {
    const stats = PokemonStats(
      hp: 45,
      attack: 49,
      defense: 49,
      specialAttack: 65,
      specialDefense: 65,
      speed: 45,
    );

    const pokemon = Pokemon(
      id: 1,
      name: 'bulbasaur',
      imageUrl: 'https://example.com/bulbasaur.png',
      type: 'grass',
      ability: 'overgrow',
      height: 7,
      weight: 69,
      stats: stats,
    );

    test('defaults isFavorite to false', () {
      expect(pokemon.isFavorite, isFalse);
    });

    test('copyWith replaces isFavorite while keeping other fields', () {
      final favorite = pokemon.copyWith(isFavorite: true);

      expect(favorite.isFavorite, isTrue);
      expect(favorite.id, pokemon.id);
      expect(favorite.name, pokemon.name);
      expect(favorite.stats, pokemon.stats);
    });

    test('copyWith without arguments preserves isFavorite', () {
      final favorite = pokemon.copyWith(isFavorite: true);

      expect(favorite.copyWith(), equals(favorite));
    });

    test('two instances with the same values are equal', () {
      const other = Pokemon(
        id: 1,
        name: 'bulbasaur',
        imageUrl: 'https://example.com/bulbasaur.png',
        type: 'grass',
        ability: 'overgrow',
        height: 7,
        weight: 69,
        stats: stats,
      );

      expect(pokemon, equals(other));
    });

    test('instances differing in isFavorite are not equal', () {
      expect(pokemon, isNot(equals(pokemon.copyWith(isFavorite: true))));
    });
  });
}
