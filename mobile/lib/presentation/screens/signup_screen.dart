// lib/presentation/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  bool _obscure = true;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      _shakeController.forward().then((_) => _shakeController.reset());
      return;
    }
    setState(() => _isLoading = true);
    try {
      await context.read<AuthProvider>().register(_name.text, _email.text, _password.text);
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _shakeController.forward().then((_) => _shakeController.reset());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark ? [Colors.purple[900]!, Colors.black] : [Colors.purple.shade400, Colors.pink.shade400],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (ctx, child) => Transform.translate(
                offset: Offset(10 * _shakeAnimation.value * (2 * _shakeAnimation.value - 1), 0),
                child: child,
              ),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                color: isDark ? Colors.grey[850] : Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(radius: 50, backgroundColor: Colors.purple.withOpacity(0.2), child: const Icon(Icons.person_add, size: 50, color: Colors.purple)),
                        const SizedBox(height: 20),
                        Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: theme.textTheme.bodyMedium?.color)),
                        const SizedBox(height: 8),
                        Text('Join the shopping revolution!', style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (v) => v!.isEmpty ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (v) => v!.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscure = !_obscure)),
                            filled: true,
                            fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signup,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 8),
                            child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? '),
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}