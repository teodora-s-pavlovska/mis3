import '../../models/joke_model.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  final List<Joke> _favorites = [];

  List<Joke> get favorites => List.unmodifiable(_favorites);

  void addToFavorites(Joke joke) {
    if (!_favorites.any((fav) => fav.id == joke.id)) {
      _favorites.add(joke);
    }
  }

  void removeFromFavorites(Joke joke) {
    _favorites.removeWhere((fav) => fav.id == joke.id);
  }

  bool isFavorite(Joke joke) {
    return _favorites.any((fav) => fav.id == joke.id);
  }
}
