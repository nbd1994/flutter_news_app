import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'News App',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 50),
              ElevatedButton.icon(
                icon: Image.asset(
                  'assets/google_logo.png',
                  height: 24.0,
                ),
                label: Text('Sign in with Google'),
                onPressed: () async {
                  try {
                    final userCredential =
                        await _authService.signInWithGoogle();
                    if (userCredential != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to sign in')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
