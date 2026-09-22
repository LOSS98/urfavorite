import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/product_list_controller.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';
import '../utils/view_mode.dart';
import '../widgets/product_list_view.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  late final ApiService _api;
  late ProductListController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _api = context.read<ApiService>();
    _controller = ProductListController((skip) => _api.searchProducts(_query, skip: skip));
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = value.trim();
      setState(() => _query = trimmed);
      if (trimmed.isEmpty) return;
      _controller = ProductListController((skip) => _api.searchProducts(trimmed, skip: skip));
      _controller.loadInitial();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          focusNode: _focusNode,
          onChanged: _onChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search products…',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _query.isEmpty
          ? const _SearchHint()
          : ChangeNotifierProvider<ProductListController>.value(
              value: _controller,
              child: ProductListView(
                viewMode: ProductViewMode.detailed,
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

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded, size: 56, color: AppColors.textSecondary),
            SizedBox(height: 16),
            Text('Search for products by name', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
