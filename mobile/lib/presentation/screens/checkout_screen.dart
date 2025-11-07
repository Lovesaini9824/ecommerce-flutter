// lib/presentation/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../core/services/api_service.dart';
import 'order_success_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _addressLine = TextEditingController();
  final _landmark = TextEditingController();

  String paymentMethod = 'cod';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _field(_fullName, 'Full Name *'),
              _field(_phone, 'Phone *', keyboardType: TextInputType.phone),
              _field(_pincode, 'Pincode *', keyboardType: TextInputType.number),
              _field(_city, 'City *'),
              _field(_state, 'State *'),
              _field(_addressLine, 'Flat, House no. *'),
              _field(_landmark, 'Landmark (Optional)'),

              const SizedBox(height: 20),
              const Text('Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              RadioListTile<String>(title: const Text('Cash on Delivery'), value: 'cod', groupValue: paymentMethod, onChanged: (v) => setState(() => paymentMethod = v!)),
              RadioListTile<String>(title: const Text('Pay Online (UPI QR)'), value: 'online', groupValue: paymentMethod, onChanged: (v) => setState(() => paymentMethod = v!)),

              if (paymentMethod == 'online')
                Center(child: QrImageView(data: 'upi://pay?pa=merchant@upi&am=${cart.total}&cu=INR', size: 200)),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _placeOrder,
                  child: _loading ? const CircularProgressIndicator(color: Colors.white) : Text('Place Order - ₹${cart.total.toStringAsFixed(0)}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: c,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
        validator: (v) => label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ApiService.post('/orders', {
        'paymentMethod': paymentMethod,
        'address': {
          'fullName': _fullName.text,
          'phone': _phone.text,
          'pincode': _pincode.text,
          'city': _city.text,
          'state': _state.text,
          'addressLine': _addressLine.text,
          'landmark': _landmark.text,
        },
      });
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }
}