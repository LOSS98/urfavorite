import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_list_controller.dart';
import '../theme/app_theme.dart';
import '../utils/view_mode.dart';
import 'product_grid_card.dart';
import 'product_list_tile.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.viewMode,
    required this.onProductTap,
    this.header,
  });

  final ProductViewMode viewMode;
  final ValueChanged<Product> onProductTap;
  final Widget? header;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400) {
      context.read<ProductListController>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductListController>();

    if (controller.isLoading && controller.products.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryStart));
    }

    if (controller.error != null && controller.products.isEmpty) {
      return _ErrorState(
        message: controller.error!,
        onRetry: () => context.read<ProductListController>().loadInitial(),
      );
    }

    if (controller.products.isEmpty) {
      return const _EmptyResults();
    }

    return RefreshIndicator(
      color: AppColors.primaryStart,
      onRefresh: () => context.read<ProductListController>().refresh(),
      child: widget.viewMode == ProductViewMode.compact
          ? _buildGrid(controller)
          : _buildList(controller),
    );
  }

  Widget _buildGrid(ProductListController controller) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (widget.header != null) SliverToBoxAdapter(child: widget.header),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.66,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductGridCard(
                product: controller.products[index],
                onTap: () => widget.onProductTap(controller.products[index]),
              ),
              childCount: controller.products.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildFooter(controller)),
      ],
    );
  }

  Widget _buildList(ProductListController controller) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        if (widget.header != null) SliverToBoxAdapter(child: widget.header),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductListTile(
                product: controller.products[index],
                onTap: () => widget.onProductTap(controller.products[index]),
              ),
              childCount: controller.products.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildFooter(controller)),
      ],
    );
  }

  Widget _buildFooter(ProductListController controller) {
    if (!controller.isLoadingMore) return const SizedBox(height: 12);
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.primaryStart),
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off_rounded, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
