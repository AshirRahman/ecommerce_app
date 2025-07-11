import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/background_svg.dart';
import '../widgets/search_box.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_list.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ProductProvider>(context, listen: false).loadProducts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final List<Product> products = productProvider.products;
    final categories = [
      "All",
      "electronics",
      "jewelery",
      "men's clothing",
      "women's clothing",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Now',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ),
        ],
      ),


      body: Stack(
        children: [
          const BackgroundSVG(), // ✅ reusable
          Column(
            children: [
              const SearchBox(),
              CategoryChips(categories: categories),
              ProductList(products: products),
            ],
          ),
        ],
      ),
    );
  }
}
