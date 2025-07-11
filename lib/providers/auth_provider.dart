import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => _auth.currentUser != null;

  Future<void> login(String email, String password, BuildContext context) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    await Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    notifyListeners();
  }

  Future<void> register(String email, String password, BuildContext context) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await Provider.of<FavoritesProvider>(context, listen: false).loadFavorites();
    notifyListeners();
  }


  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
