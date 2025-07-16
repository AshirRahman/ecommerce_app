import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ✅ FIXED: This must be a mutable field, not a getter
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((_, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // ✅ Add or update item in cart and sync with Firebase
  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
            (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items[product.id] = CartItem(
        id: product.id,
        title: product.title,
        price: product.price,
        quantity: 1,
      );
    }

    await _saveToFirebase();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveToFirebase();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _saveToFirebase();
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
      _saveToFirebase();
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      final current = _items[productId]!;
      if (current.quantity > 1) {
        _items.update(
          productId,
              (existing) => CartItem(
            id: existing.id,
            title: existing.title,
            price: existing.price,
            quantity: existing.quantity - 1,
          ),
        );
      } else {
        _items.remove(productId);
      }
      _saveToFirebase();
      notifyListeners();
    }
  }

  // ✅ Load cart from Firebase when user logs in
  Future<void> loadCart() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _db.collection('carts').doc(user.uid).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final loadedItems = <String, CartItem>{};

      data.forEach((key, value) {
        loadedItems[key] = CartItem(
          id: value['id'],
          title: value['title'],
          price: (value['price'] as num).toDouble(),
          quantity: value['quantity'],
        );
      });

      _items.clear();
      _items.addAll(loadedItems);
      notifyListeners();
    }
  }

  // ✅ Save current cart to Firebase
  Future<void> _saveToFirebase() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final cartMap = _items.map(
          (key, item) => MapEntry(key, {
        'id': item.id,
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
      }),
    );

    await _db.collection('carts').doc(user.uid).set(cartMap);
  }
}
