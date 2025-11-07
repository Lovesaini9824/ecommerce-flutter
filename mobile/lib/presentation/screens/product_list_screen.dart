// lib/presentation/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/product_card.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../core/services/api_service.dart';
import '../../data/models/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    context.read<CartProvider>().fetchCart();
  }

  Future<void> _loadProducts() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService.get('/products');
      setState(() {
        products = (data as List).map((j) => Product.fromJson(j)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Live', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.receipt_long), onPressed: () => Navigator.pushNamed(context, '/my-orders')),
          Consumer<CartProvider>(
            builder: (ctx, cart, _) => Stack(
              children: [
                IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => Navigator.pushNamed(context, '/cart')),
                if (cart.items.isNotEmpty)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('${cart.items.length}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
          IconButton(
            icon: Consumer<ThemeProvider>(
              builder: (ctx, theme, _) => Icon(theme.isDark ? Icons.light_mode : Icons.dark_mode),
            ),
            onPressed: () => context.read<ThemeProvider>().toggle(),
          ),
        ],
      ),
      body: isLoading
          ? _buildShimmer()
          : error != null
          ? _buildError()
          : RefreshIndicator(
        onRefresh: _loadProducts,
        color: Colors.indigo,
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(product: products[i]),
        ),
      ),
    );
  }

  Widget _buildShimmer() => GridView.builder(
    padding: const EdgeInsets.all(12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68, mainAxisSpacing: 8, crossAxisSpacing: 8),
    itemCount: 6,
    itemBuilder: (_, i) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), margin: const EdgeInsets.all(4)),
    ),
  );

  Widget _buildError() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 60, color: Colors.red),
        const SizedBox(height: 16),
        Text('Failed to load', style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 8),
        ElevatedButton(onPressed: _loadProducts, child: const Text('Retry')),
      ],
    ),
  );
}