/*
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
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Set<String> _favoriteIds = {};
  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data != null && data['favorites'] is List) {
      _favoriteIds = Set<String>.from(data['favorites']);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    notifyListeners();

    await _firestore.collection('users').doc(user.uid).set({
      'favorites': _favoriteIds.toList(),
    }, SetOptions(merge: true));
  }
}

