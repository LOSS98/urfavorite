import 'package:flutter/foundation.dart';

import '../models/category.dart';
import '../services/api_service.dart';

class CatalogProvider extends ChangeNotifier {
  CatalogProvider(this._api);

  final ApiService _api;

  List<ProductCategory> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<ProductCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final categories = await _api.fetchCategories();
      final coverPage = await _api.fetchProducts(skip: 0, limit: 0, select: 'category,thumbnail');

      final covers = <String, String>{};
      for (final product in coverPage.products) {
        covers.putIfAbsent(product.category, () => product.thumbnail);
      }

      _categories = categories
          .map((category) => category.copyWith(coverImage: covers[category.slug] ?? ''))
          .toList();
    } catch (e) {
      _error = 'Unable to load categories.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
