import 'package:flutter/material.dart';
import '../services/news_service.dart';
// import 'package:provider/provider.dart';
import '../models/article.dart';
import '../widgets/article_card.dart';
import '../widgets/category_chips.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  final ScrollController _scrollController = ScrollController();
  List<Article> articles = [];
  String? selectedCategory;
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadNews() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final newArticles = await _newsService.getTopHeadlines(
        category: selectedCategory,
        page: currentPage,
      );

      setState(() {
        articles.addAll(newArticles);
        currentPage++;
        isLoading = false;
        hasMore = newArticles.isNotEmpty;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load news')),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadNews();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      articles.clear();
      currentPage = 1;
      hasMore = true;
    });
    await _loadNews();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    final AuthService _authService = AuthService();
    final user = _authService.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, '/bookmarks'),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          InkWell(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(user.photoURL ?? ''),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          CategoryChips(
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
                articles.clear();
                currentPage = 1;
                hasMore = true;
              });
              _loadNews();
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: articles.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == articles.length) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ArticleCard(article: articles[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
