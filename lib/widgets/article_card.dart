import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_news_app/screens/article_detail_screen.dart';
import '../models/article.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final bool showBookmarkButton;
  final VoidCallback? onBookmarkChanged;

  const ArticleCard({
    required this.article,
    this.showBookmarkButton = true,
    this.onBookmarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (showBookmarkButton)
                    BookmarkButton(
                      article: article,
                      onBookmarkChanged: onBookmarkChanged,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BookmarkButton widget - Added in the same file
class BookmarkButton extends StatefulWidget {
  final Article article;
  final VoidCallback? onBookmarkChanged;

  const BookmarkButton({
    required this.article,
    this.onBookmarkChanged,
  });

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  late Future<DatabaseService> _databaseServiceFuture;
  final AuthService _authService = AuthService();
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _databaseServiceFuture = DatabaseService.create();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final databaseService = await _databaseServiceFuture;
    final bookmarked = await databaseService.isBookmarked(
      _authService.currentUser!.uid,
      widget.article.description,
    );
    if (mounted) {
      setState(() => isBookmarked = bookmarked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DatabaseService>(
      future: _databaseServiceFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: null,
          );
        }

        final databaseService = snapshot.data!;

        return IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          ),
          onPressed: () async {
            try {
              if (isBookmarked) {
                await databaseService.removeBookmark(
                  _authService.currentUser!.uid,
                  widget.article.description,
                );
              } else {
                await databaseService.addBookmark(
                  _authService.currentUser!.uid,
                  widget.article,
                );
              }
              setState(() => isBookmarked = !isBookmarked);
              widget.onBookmarkChanged?.call();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      isBookmarked ? 'Article bookmarked' : 'Bookmark removed'),
                  duration: Duration(seconds: 2),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update bookmark')),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}
