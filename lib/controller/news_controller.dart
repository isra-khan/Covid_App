import 'dart:convert';
import 'package:covidapp/Model/country_model.dart';
import 'package:covidapp/Model/news_article.dart';
import 'package:covidapp/constant/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NewsController extends GetxController {
  static const String _gnewsKey = String.fromEnvironment(
    'GNEWS_KEY',
    defaultValue: 'f3d21389913a22602c22b226267d459f',
  );

  Rxn<CountryModel> selectedCountry = Rxn<CountryModel>();
  RxList<NewsArticle> articles = <NewsArticle>[].obs;
  RxBool isLoading = false.obs;
  RxnString error = RxnString();

  final Map<String, _CacheEntry> _cache = {};

  bool get hasApiKey => _gnewsKey.isNotEmpty;

  Future<void> loadFor(CountryModel c) async {
    selectedCountry.value = c;
    if (!hasApiKey) {
      error.value =
          'GNews API key missing. Pass --dart-define=GNEWS_KEY=YOUR_KEY when running.';
      articles.clear();
      return;
    }
    final cacheKey = c.country;
    if (cacheKey.isEmpty) {
      error.value = 'No country name available.';
      articles.clear();
      return;
    }
    final cached = _cache[cacheKey];
    if (cached != null &&
        DateTime.now().difference(cached.fetchedAt).inMinutes < 5) {
      articles.assignAll(cached.articles);
      error.value = null;
      return;
    }
    isLoading.value = true;
    error.value = null;
    try {
      final res =
          await http.get(Uri.parse(AppUrl.newsApi(cacheKey, _gnewsKey)));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final list = (data['articles'] as List? ?? [])
            .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>))
            .toList();
        articles.assignAll(list);
        _cache[cacheKey] = _CacheEntry(list, DateTime.now());
      } else {
        error.value = 'News API returned ${res.statusCode}.';
      }
    } catch (_) {
      error.value = 'Failed to load news.';
    } finally {
      isLoading.value = false;
    }
  }
}

class _CacheEntry {
  final List<NewsArticle> articles;
  final DateTime fetchedAt;
  _CacheEntry(this.articles, this.fetchedAt);
}
