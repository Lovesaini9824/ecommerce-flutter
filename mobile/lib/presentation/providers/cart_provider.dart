// lib/presentation/providers/cart_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../core/services/api_service.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];
  List<Product> get items => _items;
  double get total => _items.fold(0, (sum, p) => sum + p.price);

  Future<void> fetchCart() async {
    try {
      final data = await ApiService.get('/cart');
      _items = (data['items'] as List).map((j) => Product.fromJson(j)).toList();
    } catch (_) {
      _items = [];
    }
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    await ApiService.post('/cart', {'productId': product.id});
    _items.add(product);
    notifyListeners();
  }
}