// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/cart_screen.dart';
import 'presentation/screens/order_success_screen.dart';
import 'presentation/screens/checkout_screen.dart';
import 'presentation/screens/my_orders_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadSession()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Live',
      theme: theme.isDark ? _darkTheme : _lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const _RootScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const ProductListScreen(),
        '/cart': (_) => const CartScreen(),
        '/checkout': (_) => const CheckoutScreen(),
        '/my-orders': (_) => const MyOrdersScreen(),
        '/order-success': (_) => const OrderSuccessScreen(),
      },
    );
  }
}

final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey[50],
  cardColor: Colors.white,
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black87)),
);

final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[850],
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white70)),
);

class _RootScreen extends StatelessWidget {
  const _RootScreen();
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    Future.microtask(() => Navigator.pushReplacementNamed(context, auth.isLoggedIn! ? '/home' : '/login'));
    return const SizedBox.shrink();
  }
}