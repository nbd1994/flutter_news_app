import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class DatabaseService {
  static const String _bookmarksKey = 'user_bookmarks';
  final SharedPreferences _prefs;

  DatabaseService._internal(this._prefs);

  static Future<DatabaseService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return DatabaseService._internal(prefs);
  }

  Future<void> addBookmark(String userId, Article article) async {
    try {
      final bookmarks = _getBookmarksMap();

      if (!bookmarks.containsKey(userId)) {
        bookmarks[userId] = {};
      }

      bookmarks[userId]![article.description] = {
        ...article.toJson(),
        'bookmarkedAt': DateTime.now().toIso8601String(),
      };

      await _saveBookmarks(bookmarks);
    } catch (e) {
      throw Exception('Failed to bookmark article: $e');
    }
  }

  Future<void> removeBookmark(String userId, String articleId) async {
    try {
      final bookmarks = _getBookmarksMap();

      if (bookmarks.containsKey(userId)) {
        bookmarks[userId]!.remove(articleId);
        await _saveBookmarks(bookmarks);
      }
    } catch (e) {
      throw Exception('Failed to remove bookmark: $e');
    }
  }

  List<Article> getBookmarks(String userId) {
    try {
      final bookmarks = _getBookmarksMap();

      if (!bookmarks.containsKey(userId)) {
        return [];
      }
      print(bookmarks[userId]!.values);
      return bookmarks[userId]!
          .values
          .map((articleData) =>
              Article.fromJson(Map<String, dynamic>.from(articleData)))
          .toList()
        ..sort((a, b) =>
            DateTime.parse(bookmarks[userId]![b.description]!['bookmarkedAt'])
                .compareTo(DateTime.parse(
                    bookmarks[userId]![a.description]!['bookmarkedAt'])));
    } catch (e) {
      print('Error getting bookmarks: $e');
      return [];
    }
  }

  Future<bool> isBookmarked(String userId, String articleId) async {
    final bookmarks = _getBookmarksMap();
    return bookmarks[userId]?.containsKey(articleId) ?? false;
  }

  Map<String, Map<String, dynamic>> _getBookmarksMap() {
    final String? storedData = _prefs.getString(_bookmarksKey);
    if (storedData == null) {
      return {};
    }
    try {
      final Map<String, dynamic> decodedData = json.decode(storedData);
      return Map<String, Map<String, dynamic>>.from(
        decodedData.map(
          (key, value) => MapEntry(
            key,
            Map<String, dynamic>.from(value as Map),
          ),
        ),
      );
    } catch (e) {
      print('Error parsing bookmarks: $e');
      return {};
    }
  }

  Future<void> _saveBookmarks(
      Map<String, Map<String, dynamic>> bookmarks) async {
    await _prefs.setString(_bookmarksKey, jsonEncode(bookmarks));
  }

  Future<void> clearUserBookmarks(String userId) async {
    final bookmarks = _getBookmarksMap();
    bookmarks.remove(userId);
    await _saveBookmarks(bookmarks);
  }

  Future<void> clearAllBookmarks() async {
    await _prefs.remove(_bookmarksKey);
  }
}
