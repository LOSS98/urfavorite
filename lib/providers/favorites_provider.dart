import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String _storageKey = 'favorite_products';

  final Map<int, Product> _favorites = {};
  bool _isReady = false;

  bool get isReady => _isReady;

  List<Product> get favorites => _favorites.values.toList(growable: false);

  int get count => _favorites.length;

  bool isFavorite(int productId) => _favorites.containsKey(productId);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey) ?? const [];
    for (final entry in stored) {
      final json = jsonDecode(entry) as Map<String, dynamic>;
      final product = Product.fromJson(json);
      _favorites[product.id] = product;
    }
    _isReady = true;
    notifyListeners();
  }

  Future<void> toggle(Product product) async {
    if (_favorites.containsKey(product.id)) {
      _favorites.remove(product.id);
    } else {
      _favorites[product.id] = product;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _favorites.values
        .map((product) => jsonEncode({
              'id': product.id,
              'title': product.title,
              'description': product.description,
              'category': product.category,
              'price': product.price,
              'discountPercentage': product.discountPercentage,
              'rating': product.rating,
              'stock': product.stock,
              'brand': product.brand,
              'thumbnail': product.thumbnail,
              'images': product.images,
            }))
        .toList();
    await prefs.setStringList(_storageKey, encoded);
  }
}
