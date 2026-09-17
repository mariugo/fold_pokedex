import 'package:flutter_test/flutter_test.dart';
import 'package:fold_pokedex/data/models/pokemon_model.dart';

Map<String, dynamic> _bulbasaurJson() => {
  'id': 1,
  'name': 'bulbasaur',
  'height': 7,
  'weight': 69,
  'sprites': {
    'other': {
      'official-artwork': {
        'front_default': 'https://example.com/bulbasaur.png',
      },
    },
  },
  'types': [
    {
      'slot': 1,
      'type': {'name': 'grass'},
    },
  ],
  'abilities': [
    {
      'slot': 1,
      'ability': {'name': 'overgrow'},
    },
  ],
  'stats': [
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
    {
      'base_stat': 45,
      'stat': {'name': 'speed'},
    },
  ],
};

void main() {
  group('PokemonModel.fromJson', () {
    test('extracts the top-level and nested fields from the response', () {
      final model = PokemonModel.fromJson(_bulbasaurJson());

      expect(model.id, 1);
      expect(model.name, 'bulbasaur');
      expect(model.imageUrl, 'https://example.com/bulbasaur.png');
      expect(model.type, 'grass');
      expect(model.ability, 'overgrow');
      expect(model.height, 7);
      expect(model.weight, 69);
      expect(model.stats.hp, 45);
    });
  });

  group('PokemonModel.toDomain', () {
    test('defaults isFavorite to false', () {
      final domain = PokemonModel.fromJson(_bulbasaurJson()).toDomain();

      expect(domain.isFavorite, isFalse);
    });

    test('carries the isFavorite flag supplied by the repository', () {
      final domain = PokemonModel.fromJson(_bulbasaurJson())
          .toDomain(isFavorite: true);

      expect(domain.isFavorite, isTrue);
    });

    test('maps every field onto the domain Pokemon', () {
      final model = PokemonModel.fromJson(_bulbasaurJson());
      final domain = model.toDomain();

      expect(domain.id, model.id);
      expect(domain.name, model.name);
      expect(domain.imageUrl, model.imageUrl);
      expect(domain.type, model.type);
      expect(domain.ability, model.ability);
      expect(domain.height, model.height);
      expect(domain.weight, model.weight);
      expect(domain.stats, model.stats.toDomain());
    });
  });
}
