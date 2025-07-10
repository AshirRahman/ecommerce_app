import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/dummy_data.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _allProducts = dummyProducts;
  List<Product> _filteredProducts = dummyProducts;

  List<Product> get products => _filteredProducts;

  void search(String query) {
    if (query.trim().isEmpty) {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredProducts = _allProducts;
    } else {
      _filteredProducts = _allProducts
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners();
  }

}
