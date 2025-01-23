// filepath: /c:/Users/lenovo/Desktop/flutter_news_app/lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    late AuthService _authService;
    Future<void> _initialize() async {
      _authService = await AuthService.getInstance();
      // Assuming you have a method to check if the article is bookmarked
    }

    @override
    void initState() {
      _initialize();
    }

    initState();
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.photoURL ?? ''),
                  ),
                  SizedBox(height: 20),
                  Text(
                    user.displayName ?? 'No display name',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.email ?? 'No email',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            : Text('No user is signed in'),
      ),
    );
  }
}
