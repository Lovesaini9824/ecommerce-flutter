import 'package:flutter/material.dart';
import '../../data/models/cart_item.dart';

class CartItemTile extends StatelessWidget {
  final CartItem item;
  const CartItemTile({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        item.product.image ?? 'https://via.placeholder.com/50',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
      title: Text(item.product.title),
      subtitle: Text('₹${item.product.price} × ${item.qty}'),
      trailing: Text('₹${item.product.price * item.qty}'),
    );
  }
}