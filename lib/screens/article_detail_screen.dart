import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Details'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.share),
          //   onPressed: () {
          //     Share.share(
          //       '${article.title}\n\nRead more at: ${article.url}',
          //     );
          //   },
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.source, size: 16),
                      SizedBox(width: 4),
                      Text(
                        article.source,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(article.publishedAt),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (article.description.isNotEmpty)
                    Text(
                      article.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  SizedBox(height: 16),
                  if (article.content.isNotEmpty)
                    Text(
                      article.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  SizedBox(height: 24),
                  // ElevatedButton(
                  //   onPressed: () => _launchURL(article.url),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Read Full Article'),
                  //       SizedBox(width: 8),
                  //       Icon(Icons.launch, size: 16),
                  //     ],
                  //   ),
                  //   style: ElevatedButton.styleFrom(
                  //     padding: EdgeInsets.symmetric(vertical: 12),
                  //     minimumSize: Size(double.infinity, 0),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Future<void> _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
