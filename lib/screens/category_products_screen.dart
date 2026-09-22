import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_list_controller.dart';
import '../services/api_service.dart';
import '../utils/view_mode.dart';
import '../widgets/product_list_view.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key, required this.slug, required this.name});

  final String slug;
  final String name;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  ProductViewMode _viewMode = ProductViewMode.compact;

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return ChangeNotifierProvider<ProductListController>(
      create: (_) => ProductListController(
        (skip) => api.fetchProductsByCategory(widget.slug, skip: skip),
      )..loadInitial(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          actions: [
            IconButton(
              icon: Icon(
                _viewMode == ProductViewMode.compact
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              onPressed: () => setState(() {
                _viewMode = _viewMode == ProductViewMode.compact
                    ? ProductViewMode.detailed
                    : ProductViewMode.compact;
              }),
            ),
          ],
        ),
        body: ProductListView(
          viewMode: _viewMode,
          onProductTap: (Product product) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(productId: product.id, seed: product),
            ),
          ),
        ),
      ),
    );
  }
}
