import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/domain/entities/pokemon_stats.dart';

void main() {
  group('PokemonStats', () {
    const stats = PokemonStats(
      hp: 45,
      attack: 49,
      defense: 49,
      specialAttack: 65,
      specialDefense: 65,
      speed: 45,
    );

    test('exposes the values passed to the constructor', () {
      expect(stats.hp, 45);
      expect(stats.attack, 49);
      expect(stats.defense, 49);
      expect(stats.specialAttack, 65);
      expect(stats.specialDefense, 65);
      expect(stats.speed, 45);
    });

    test('two instances with the same values are equal', () {
      const other = PokemonStats(
        hp: 45,
        attack: 49,
        defense: 49,
        specialAttack: 65,
        specialDefense: 65,
        speed: 45,
      );

      expect(stats, equals(other));
      expect(stats.hashCode, equals(other.hashCode));
    });

    test('instances differing in a single field are not equal', () {
      const other = PokemonStats(
        hp: 1,
        attack: 49,
        defense: 49,
        specialAttack: 65,
        specialDefense: 65,
        speed: 45,
      );

      expect(stats, isNot(equals(other)));
    });
  });
}
