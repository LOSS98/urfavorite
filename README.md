# UrFavorite

**5A ICY FISA - Binôme : Khalil Mzoughi & Franck Maruis**

Mini-catalogue produits en Flutter (iOS & Android) avec gestion de favoris. Toutes les données (produits, catégories, images) viennent de l'API [DummyJSON](https://dummyjson.com) en direct, aucune donnée mockée.

## Données

`lib/services/api_service.dart` appelle `GET /products` (fil paginé), `GET /products/{id}` (détail), `GET /products/search` (recherche), `GET /products/categories` (catégories) et `GET /products/category/{slug}` (filtre par catégorie). Comme l'API ne fournit pas d'image par catégorie, l'app récupère tous les produits une fois au démarrage et utilise la miniature du premier produit de chaque catégorie. Les favoris sont sauvegardés en local avec `shared_preferences`.

## Écrans

**Accueil** : logo, recherche, bascule vue compacte/détaillée, catégories, fil de produits paginé.

**Catégorie** : produits filtrés par catégorie, même bascule d'affichage.

**Recherche** : champ avec debounce, résultats en vue détaillée.

**Fiche produit** : carrousel d'images, prix, note, stock, description, bouton favoris.

**Favoris** : liste filtrée sur les favoris, compteur en badge, persistante entre sessions.

## Lancer

```bash
flutter pub get
flutter run
```
