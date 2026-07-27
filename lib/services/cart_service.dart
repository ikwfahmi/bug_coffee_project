import 'package:flutter/foundation.dart';
import 'package:bugcoffee/models/product.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();

  factory CartService() {
    return instance;
  }

  CartService._internal() {
    // Add default initial items for quick demo experience
    _cartItems.add(CartItem(
      product: sampleProducts[0], // Coffee Latte
      quantity: 1,
      temperature: 'Ice',
      sugarLevel: '100%',
    ));
    _cartItems.add(CartItem(
      product: sampleProducts[4], // Matcha Latte
      quantity: 1,
      temperature: 'Ice',
      sugarLevel: '50%',
    ));
  }

  final List<CartItem> _cartItems = [];
  double _discountRate = 0.0;
  String _appliedVoucher = '';
  String _customerName = 'Guest User';
  String _orderType = 'Dine In';
  String _tableNumber = 'T-08';

  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  String get customerName => _customerName;
  String get orderType => _orderType;
  String get tableNumber => _tableNumber;
  String get appliedVoucher => _appliedVoucher;

  void setCustomerDetails({required String name, required String type, String table = ''}) {
    _customerName = name.isEmpty ? 'Guest User' : name;
    _orderType = type;
    _tableNumber = table.isEmpty ? '-' : table;
    notifyListeners();
  }

  int get totalItemCount {
    int count = 0;
    for (var item in _cartItems) {
      count += item.quantity;
    }
    return count;
  }

  double get subtotal {
    double total = 0;
    for (var item in _cartItems) {
      if (item.isChecked) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  double get discountAmount => subtotal * _discountRate;

  double get taxAndService => (subtotal - discountAmount) * 0.10; // 10% tax

  double get grandTotal {
    double result = subtotal - discountAmount + taxAndService;
    return result < 0 ? 0 : result;
  }

  void addToCart(Product product, {String temp = 'Ice', String sugar = '100%', int quantity = 1}) {
    // Check if item with same options already exists
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id && item.temperature == temp && item.sugarLevel == sugar,
    );

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        temperature: temp,
        sugarLevel: sugar,
        isChecked: true,
      ));
    }
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity += delta;
      if (_cartItems[index].quantity <= 0) {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      notifyListeners();
    }
  }

  void toggleItemCheck(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].isChecked = !_cartItems[index].isChecked;
      notifyListeners();
    }
  }

  bool applyVoucher(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'BUGCOFFEE20' || cleanCode == 'DISCOUNT20') {
      _discountRate = 0.20;
      _appliedVoucher = cleanCode;
      notifyListeners();
      return true;
    } else if (cleanCode == 'WELCOME10') {
      _discountRate = 0.10;
      _appliedVoucher = cleanCode;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _discountRate = 0.0;
    _appliedVoucher = '';
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _discountRate = 0.0;
    _appliedVoucher = '';
    notifyListeners();
  }
}
