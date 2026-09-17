import 'package:equatable/equatable.dart';
import 'package:fold_pokedex/domain/entities/pokemon_stats.dart';

/// A Pokémon and the details shown across the app.
///
/// This is the clean domain representation used by the UI layer. It has no
/// knowledge of the API response shape or the local persistence mechanism.
final class Pokemon extends Equatable {
  /// Creates an immutable Pokémon.
  const new({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.ability,
    required this.height,
    required this.weight,
    required this.stats,
    this.isFavorite = false,
  });

  /// The National Pokédex number.
  final int id;

  /// The Pokémon's name.
  final String name;

  /// The URL of the official artwork.
  final String imageUrl;

  /// The primary elemental type, e.g. `'grass'`.
  final String type;

  /// The primary ability name.
  final String ability;

  /// The height in decimetres, as returned by the source API.
  final int height;

  /// The weight in hectograms, as returned by the source API.
  final int weight;

  /// The base battle stats.
  final PokemonStats stats;

  /// Whether the user has marked this Pokémon as a favorite.
  final bool isFavorite;

  /// Returns a copy with [isFavorite] replaced.
  Pokemon copyWith({bool? isFavorite}) {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      type: type,
      ability: ability,
      height: height,
      weight: weight,
      stats: stats,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    type,
    ability,
    height,
    weight,
    stats,
    isFavorite,
  ];
}
