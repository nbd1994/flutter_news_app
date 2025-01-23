import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';

class BookmarksScreen extends StatefulWidget {
  @override
  _BookmarksScreenState createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  late Future<DatabaseService> _databaseServiceFuture;
  late AuthService _authService;
  Future<void> _initialize() async {
    _authService = await AuthService.getInstance();
    // Assuming you have a method to check if the article is bookmarked
  }

  List<Article> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _databaseServiceFuture = DatabaseService.create();
    _loadBookmarks();
    _initialize();
  }

  Future<void> _loadBookmarks() async {
    final databaseService = await _databaseServiceFuture;
    setState(() {
      bookmarks = databaseService.getBookmarks(_authService.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: FutureBuilder<DatabaseService>(
        future: _databaseServiceFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (bookmarks.isEmpty) {
            return Center(
              child: Text('No bookmarks yet'),
            );
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return ArticleCard(
                article: bookmarks[index],
                showBookmarkButton: true,
                onBookmarkChanged: () {
                  _loadBookmarks();
                },
              );
            },
          );
        },
      ),
    );
  }
}
