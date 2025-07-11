import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthProvider from the app
    final authProvider = Provider.of<AuthProvider>(context);

    // If the user is logged in, show the HomeScreen
    if (authProvider.isLoggedIn) {
      return const HomeScreen();
    }

    // If not logged in, show the LoginScreen
    return const LoginScreen();
  }
}
