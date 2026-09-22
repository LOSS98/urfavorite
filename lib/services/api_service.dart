import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/category.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com';
  static const int pageSize = 20;

  Future<ProductsPage> fetchProducts({int skip = 0, int limit = pageSize, String? select}) async {
    final selectParam = select != null ? '&select=$select' : '';
    final uri = Uri.parse('$_baseUrl/products?limit=$limit&skip=$skip$selectParam');
    final response = await http.get(uri);
    _ensureOk(response);
    return ProductsPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<ProductsPage> fetchProductsByCategory(
    String slug, {
    int skip = 0,
    int limit = pageSize,
  }) async {
    final uri = Uri.parse('$_baseUrl/products/category/$slug?limit=$limit&skip=$skip');
    final response = await http.get(uri);
    _ensureOk(response);
    return ProductsPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<ProductsPage> searchProducts(String query, {int skip = 0, int limit = pageSize}) async {
    final uri = Uri.parse(
      '$_baseUrl/products/search?q=${Uri.encodeQueryComponent(query)}&limit=$limit&skip=$skip',
    );
    final response = await http.get(uri);
    _ensureOk(response);
    return ProductsPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Product> fetchProduct(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(uri);
    _ensureOk(response);
    return Product.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<ProductCategory>> fetchCategories() async {
    final uri = Uri.parse('$_baseUrl/products/categories');
    final response = await http.get(uri);
    _ensureOk(response);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void _ensureOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('Request failed with status ${response.statusCode}');
    }
  }
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}
