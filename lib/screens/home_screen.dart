import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/cart_screen.dart';
import '../widgets/search_box.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final List<Product> products = productProvider.products;
    final categories = ['All', 'Clothing', 'Shoes', 'Electronics'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop Now',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
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
        ],
      ),
      body: Column(
        children: [
          const SearchBox(),
          CategoryChips(categories: categories),
          ProductList(products: products),
        ],
      ),
    );
  }
}
