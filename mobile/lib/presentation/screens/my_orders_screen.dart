// lib/presentation/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List orders = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final data = await ApiService.get('/orders/my');
      setState(() {
        orders = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : orders.isEmpty
                  ? const Center(child: Text('No orders yet'))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (_, i) {
                        final o = orders[i];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            title: Text('Order #${o['orderId']}'),
                            subtitle: Text('${o['items'].length} items • ₹${o['total']} • ${o['status']}'),
                            trailing: Text((o['paymentMethod'] ?? 'COD').toUpperCase()),
                          ),
                        );
                      },
                    ),
    );
  }
}