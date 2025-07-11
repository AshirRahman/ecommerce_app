import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the auth provider
    final authProvider = Provider.of<AuthProvider>(context);

    // Check if user is logged in or not
    final loggedIn = authProvider.isAuthenticated;

    // Show HomeScreen if logged in, else show LoginScreen
    if (loggedIn) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
