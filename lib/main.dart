import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/catalog_provider.dart';
import 'providers/favorites_provider.dart';
import 'screens/root_shell.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const UrFavoriteApp());
}

class UrFavoriteApp extends StatelessWidget {
  const UrFavoriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => FavoritesProvider()..load(),
        ),
        ChangeNotifierProvider<CatalogProvider>(
          create: (context) => CatalogProvider(context.read<ApiService>())..loadCategories(),
        ),
      ],
      child: MaterialApp(
        title: 'UrFavorite',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const RootShell(),
      ),
    );
  }
}
