import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _didLoadFavorites = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadFavorites) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final favProvider = Provider.of<FavoritesProvider>(context, listen: false);

      // If the user is already logged in (restored session)
      if (auth.isLoggedIn) {
        favProvider.loadFavorites(); // Load favorites from Firebase
      }

      _didLoadFavorites = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current authentication status
    final auth = Provider.of<AuthProvider>(context);

    // Show HomeScreen if logged in, otherwise show LoginScreen
    if (auth.isLoggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
