import 'package:flutter/foundation.dart';

import '../models/product.dart';

typedef ProductsFetcher = Future<ProductsPage> Function(int skip);

class ProductListController extends ChangeNotifier {
  ProductListController(this._fetcher);

  final ProductsFetcher _fetcher;

  final List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  Future<void> loadInitial() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final page = await _fetcher(0);
      _products
        ..clear()
        ..addAll(page.products);
      _hasMore = page.hasMore;
    } catch (e) {
      _error = 'Unable to load products. Check your connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final page = await _fetcher(_products.length);
      _products.addAll(page.products);
      _hasMore = page.hasMore;
    } catch (e) {
      _hasMore = false;
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadInitial();
}
