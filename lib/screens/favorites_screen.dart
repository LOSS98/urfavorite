import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../theme/app_theme.dart';
import '../utils/view_mode.dart';
import '../widgets/product_grid_card.dart';
import '../widgets/product_list_tile.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  ProductViewMode _viewMode = ProductViewMode.compact;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (favorites.favorites.isNotEmpty)
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
          const SizedBox(width: 4),
        ],
      ),
      body: !favorites.isReady
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryStart))
          : favorites.favorites.isEmpty
              ? const _EmptyFavorites()
              : _viewMode == ProductViewMode.compact
                  ? GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: favorites.favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites.favorites[index];
                        return ProductGridCard(
                          product: product,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(productId: product.id, seed: product),
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: favorites.favorites.length,
                      itemBuilder: (context, index) {
                        final product = favorites.favorites[index];
                        return ProductListTile(
                          product: product,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(productId: product.id, seed: product),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.85,
              child: Image.asset('assets/images/logo_full.png', width: 160),
            ),
            const SizedBox(height: 20),
            const Text(
              'No favorites yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
