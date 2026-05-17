import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _storageKey = 'favorite_keys';

  final Set<String> _favoriteKeys = {};

  FavoritesProvider() {
    _loadFavorites();
  }

  String _makeKey(String type, String id) => '$type:$id';

  bool isFavorite(String type, String id) {
    return _favoriteKeys.contains(_makeKey(type, id));
  }

  void toggleFavorite(String type, String id) {
    final key = _makeKey(type, id);

    if (_favoriteKeys.contains(key)) {
      _favoriteKeys.remove(key);
    } else {
      _favoriteKeys.add(key);
    }

    _saveFavorites();
    notifyListeners();
  }

  List<String> get placeIds => _idsByType('place');
  List<String> get restaurantIds => _idsByType('restaurant');
  List<String> get hotelIds => _idsByType('hotel');

  List<String> _idsByType(String type) {
    return _favoriteKeys
        .where((key) => key.startsWith('$type:'))
        .map((key) => key.split(':').last)
        .toList();
  }

  bool get isEmpty => _favoriteKeys.isEmpty;

  void clearFavorites() {
    _favoriteKeys.clear();
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, _favoriteKeys.toList());
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getStringList(_storageKey) ?? [];

    _favoriteKeys
      ..clear()
      ..addAll(storedFavorites);

    notifyListeners();
  }
}