import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String _apiKey = '563853a1f97f4d98a0e72d5115c7ca69';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<Article>> getTopHeadlines({
    String country = 'us',
    String? category,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey'
            '${category != null ? '&category=$category' : ''}&page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<List<Article>> searchNews(String query, {int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey&page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}
