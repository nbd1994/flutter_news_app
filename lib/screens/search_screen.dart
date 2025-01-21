import 'package:flutter/material.dart';
import 'dart:async';
import '../services/news_service.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsService _newsService = NewsService();
  final _searchController = TextEditingController();
  Timer? _debounce;
  List<Article> searchResults = [];
  bool isLoading = false;
  String lastQuery = '';
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  Future<void> _loadMoreResults() async {
    if (isLoading || !hasMore || lastQuery.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final newArticles = await _newsService.searchNews(
        lastQuery,
        page: currentPage + 1,
      );

      setState(() {
        searchResults.addAll(newArticles);
        currentPage++;
        hasMore = newArticles.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load more results')),
      );
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          searchResults.clear();
          lastQuery = '';
          currentPage = 1;
          hasMore = true;
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      isLoading = true;
      searchResults.clear();
      currentPage = 1;
      lastQuery = query;
    });

    try {
      final articles = await _newsService.searchNews(query);
      setState(() {
        searchResults = articles;
        hasMore = articles.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search news')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search news...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          autofocus: true,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading && searchResults.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: searchResults.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == searchResults.length) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ArticleCard(article: searchResults[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
