import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => AuthScreen(),
      '/home': (context) => HomeScreen(),
      '/bookmarks': (context) => BookmarksScreen(),
      '/search': (context) => SearchScreen(),
      '/profile': (context) => ProfileScreen(),
    };
  }
}
