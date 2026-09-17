import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/data/models/pokemon_stats_model.dart';

void main() {
  group('PokemonStatsModel.fromJson', () {
    test('reads each stat by name regardless of list order', () {
      final model = PokemonStatsModel.fromJson([
        {
          'base_stat': 65,
          'stat': {'name': 'speed'},
        },
        {
          'base_stat': 45,
          'stat': {'name': 'hp'},
        },
        {
          'base_stat': 49,
          'stat': {'name': 'attack'},
        },
        {
          'base_stat': 49,
          'stat': {'name': 'defense'},
        },
        {
          'base_stat': 65,
          'stat': {'name': 'special-attack'},
        },
        {
          'base_stat': 65,
          'stat': {'name': 'special-defense'},
        },
      ]);

      expect(model.hp, 45);
      expect(model.attack, 49);
      expect(model.defense, 49);
      expect(model.specialAttack, 65);
      expect(model.specialDefense, 65);
      expect(model.speed, 65);
    });

    test('defaults missing stats to zero', () {
      final model = PokemonStatsModel.fromJson([
        {
          'base_stat': 45,
          'stat': {'name': 'hp'},
        },
      ]);

      expect(model.hp, 45);
      expect(model.attack, 0);
      expect(model.defense, 0);
      expect(model.specialAttack, 0);
      expect(model.specialDefense, 0);
      expect(model.speed, 0);
    });

    test('toDomain maps every field onto PokemonStats', () {
      final model = PokemonStatsModel.fromJson([
        {
          'base_stat': 45,
          'stat': {'name': 'hp'},
        },
        {
          'base_stat': 49,
          'stat': {'name': 'attack'},
        },
      ]);

      final domain = model.toDomain();

      expect(domain.hp, model.hp);
      expect(domain.attack, model.attack);
      expect(domain.defense, model.defense);
      expect(domain.specialAttack, model.specialAttack);
      expect(domain.specialDefense, model.specialDefense);
      expect(domain.speed, model.speed);
    });
  });
}
