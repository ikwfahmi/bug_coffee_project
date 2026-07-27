import 'package:flutter/material.dart';
import 'package:bugcoffee/cash.dart';
import 'package:bugcoffee/home_page.dart';
import 'package:bugcoffee/login.dart';
import 'package:bugcoffee/order.dart';
import 'package:bugcoffee/pembayaran.dart';
import 'package:bugcoffee/qris.dart';
import 'package:bugcoffee/shopping_cart.dart';
import 'package:bugcoffee/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BugCoffee',
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/shoppingCart': (context) => const ShoppingCartScreen(),
        '/pembayaran': (context) => const PembayaranScreen(),
        '/qris': (context) => const Qris(),
        '/cash': (context) => const KirimUangScreen(),
        '/order': (context) => const Order(),
      },
    );
  }
}