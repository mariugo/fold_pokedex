import 'package:fold_pokedex/data/models/pokemon_stats_model.dart';
import 'package:fold_pokedex/domain/entities/pokemon.dart';

/// Raw shape of a PokeAPI `pokemon/{id}` detail response.
///
/// Only the fields the app needs are extracted. Favorites are not part of
/// this model; they are merged in by the repository from local storage.
final class PokemonModel {
  /// Creates a model from already-extracted values.
  const new({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.ability,
    required this.height,
    required this.weight,
    required this.stats,
  });

  /// Parses a PokeAPI Pokémon detail response body.
  factory fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>).cast<Map<String, dynamic>>();
    final abilities = (json['abilities'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final sprites = json['sprites'] as Map<String, dynamic>;
    final otherSprites = sprites['other'] as Map<String, dynamic>;
    final officialArtwork =
        otherSprites['official-artwork'] as Map<String, dynamic>;

    return PokemonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: officialArtwork['front_default'] as String,
      type: (types.first['type'] as Map<String, dynamic>)['name'] as String,
      ability:
          (abilities.first['ability'] as Map<String, dynamic>)['name']
              as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      stats: PokemonStatsModel.fromJson(json['stats'] as List<dynamic>),
    );
  }

  /// The National Pokédex number.
  final int id;

  /// The Pokémon's name.
  final String name;

  /// The URL of the official artwork.
  final String imageUrl;

  /// The primary elemental type.
  final String type;

  /// The primary ability name.
  final String ability;

  /// The height in decimetres.
  final int height;

  /// The weight in hectograms.
  final int weight;

  /// The base battle stats.
  final PokemonStatsModel stats;

  /// Converts this model into the clean [Pokemon] domain model.
  ///
  /// [isFavorite] is supplied by the repository, since favorite state lives
  /// in local storage rather than the API response.
  Pokemon toDomain({bool isFavorite = false}) {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      type: type,
      ability: ability,
      height: height,
      weight: weight,
      stats: stats.toDomain(),
      isFavorite: isFavorite,
    );
  }
}
