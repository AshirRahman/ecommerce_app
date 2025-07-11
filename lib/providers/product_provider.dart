import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  List<Product> get products => _filteredProducts;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;
  String _searchQuery = '';

  // 🔄 Central method to apply filters
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch = product.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  // 📦 API loader
  Future<void> loadProducts() async {
    try {
      final fetched = await ProductService.fetchProducts();
      _allProducts.clear();
      _allProducts.addAll(fetched);
      _applyFilters(); // 👈 Apply any active filter
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
      rethrow;
    }
  }

  // 🔍 Search
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // 📁 Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }
}
