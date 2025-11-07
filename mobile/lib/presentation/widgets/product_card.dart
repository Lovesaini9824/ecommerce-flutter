// lib/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.cardColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  product.image ?? 'https://via.placeholder.com/300',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(height: 160, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, size: 60)),
                ),
              ),
              if (product.source != null)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: product.source == 'amazon' ? Colors.orange.shade700 : Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Text(product.source!.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                if (product.description != null && product.description!.isNotEmpty)
                  Text(product.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.white),
                          const SizedBox(width: 2),
                          Text('${product.rating?.toStringAsFixed(1) ?? '4.0'}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('(${_formatReviews(product.reviewCount ?? 100)})', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    const Spacer(),
                    SizedBox(
                      height: 36,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<CartProvider>().addToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.title} added'), backgroundColor: Colors.green, duration: const Duration(seconds: 1)));
                        },
                        icon: const Icon(Icons.add_shopping_cart, size: 16),
                        label: const Text('Add', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.indigo, side: const BorderSide(color: Colors.indigo), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<CartProvider>().addToCart(product);
                          Navigator.pushNamed(context, '/cart');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Buy', style: TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatReviews(int count) => count >= 1000 ? '${(count / 1000).toStringAsFixed(1)}K' : count.toString();
}