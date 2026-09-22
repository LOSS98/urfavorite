import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/catalog_provider.dart';
import '../providers/product_list_controller.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/view_mode.dart';
import '../widgets/category_tile.dart';
import '../widgets/product_list_view.dart';
import 'category_products_screen.dart';
import 'product_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductViewMode _viewMode = ProductViewMode.compact;

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id, seed: product)),
    );
  }

  void _openCategory(String slug, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CategoryProductsScreen(slug: slug, name: name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return ChangeNotifierProvider<ProductListController>(
      create: (_) => ProductListController(
        (skip) => api.fetchProducts(skip: skip),
      )..loadInitial(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/logo_mark.png', height: 30),
              const SizedBox(width: 10),
              const Text('UrFavorite'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
            IconButton(
              icon: Icon(
                _viewMode == ProductViewMode.compact
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
              ),
              tooltip: _viewMode == ProductViewMode.compact ? 'Detailed view' : 'Compact view',
              onPressed: () => setState(() {
                _viewMode = _viewMode == ProductViewMode.compact
                    ? ProductViewMode.detailed
                    : ProductViewMode.compact;
              }),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: ProductListView(
          viewMode: _viewMode,
          onProductTap: _openProduct,
          header: _CategoriesHeader(onCategoryTap: _openCategory),
        ),
      ),
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({required this.onCategoryTap});

  final void Function(String slug, String name) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 112,
            child: catalog.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primaryStart))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catalog.categories.length,
                    itemBuilder: (context, index) {
                      final category = catalog.categories[index];
                      return CategoryTile(
                        category: category,
                        onTap: () => onCategoryTap(category.slug, category.name),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 22),
          Text(
            'Popular products',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
