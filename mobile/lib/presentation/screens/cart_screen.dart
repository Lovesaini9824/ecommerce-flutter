// lib/presentation/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../data/models/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Cart is empty'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: cart.items.length,
        itemBuilder: (_, i) => CartItemTile(item: cart.items[i]),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Theme.of(context).cardColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ₹${cart.total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

// Simple tile – uses Product directly
class CartItemTile extends StatelessWidget {
  final Product item;
  const CartItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Image.network(
          item.image ?? 'https://via.placeholder.com/80',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text('₹${item.price.toStringAsFixed(0)}'),
        trailing: IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            // optional: remove from cart
          },
        ),
      ),
    );
  }
}