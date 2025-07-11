import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteProductIds = {};

  Set<String> get favoriteIds => _favoriteProductIds;

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
  }
}
