import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../widgets/background_svg.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final cartItems = cart.items.values.toList();
    final cartKeys = cart.items.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundSVG(),

          cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Your cart is empty.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (ctx, i) {
                    final item = cartItems[i];
                    final productId = cartKeys[i];
                    return CartItemCard(
                      item: item,
                      productId: productId,
                    ); // use your card widget or container here
                  },
                ),
        ],
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : CheckoutBar(totalAmount: cart.totalAmount),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final String productId;

  const CartItemCard({super.key, required this.item, required this.productId});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.green,
            child: Text(
              '${item.quantity}x',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.green,
                ),
                onPressed: () => cart.decreaseQuantity(productId),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () => cart.increaseQuantity(productId),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.green),
            onPressed: () => cart.removeItem(productId),
          ),
        ],
      ),
    );
  }
}

class CheckoutBar extends StatelessWidget {
  final double totalAmount;

  const CheckoutBar({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: \$${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<CartProvider>(context, listen: false).clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
