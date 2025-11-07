import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AddressScreen extends StatefulWidget {
  final Function onSaved;
  const AddressScreen({required this.onSaved, super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _pincode = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _addressLine = TextEditingController();
  final _landmark = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final data = await ApiService.get('/address');
    if (data.isNotEmpty) {
      _fullName.text = data['fullName'] ?? '';
      _phone.text = data['phone'] ?? '';
      _pincode.text = data['pincode'] ?? '';
      _city.text = data['city'] ?? '';
      _state.text = data['state'] ?? '';
      _addressLine.text = data['addressLine'] ?? '';
      _landmark.text = data['landmark'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _fullName, decoration: const InputDecoration(labelText: 'Full Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone'), keyboardType: TextInputType.phone, validator: (v) => v!.length < 10 ? 'Invalid' : null),
              TextFormField(controller: _pincode, decoration: const InputDecoration(labelText: 'Pincode'), keyboardType: TextInputType.number, validator: (v) => v!.length != 6 ? '6 digits' : null),
              TextFormField(controller: _city, decoration: const InputDecoration(labelText: 'City'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _state, decoration: const InputDecoration(labelText: 'State'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _addressLine, decoration: const InputDecoration(labelText: 'Flat, House no., Building'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _landmark, decoration: const InputDecoration(labelText: 'Landmark (Optional)')),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _loading = true);
                          await ApiService.post('/address', {
                            'fullName': _fullName.text,
                            'phone': _phone.text,
                            'pincode': _pincode.text,
                            'city': _city.text,
                            'state': _state.text,
                            'addressLine': _addressLine.text,
                            'landmark': _landmark.text,
                          });
                          widget.onSaved();
                          if (mounted) Navigator.pop(context);
                        }
                      },
                      child: const Text('Save Address'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}