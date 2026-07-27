import 'package:flutter/material.dart';
import 'package:bugcoffee/home_page.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class Order extends StatelessWidget {
  const Order({super.key});

  @override
  Widget build(BuildContext context) {
    return OrderCompletePage(
      orderId: 'BUG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      paymentMethod: 'Paid',
      totalAmount: CartService.instance.grandTotal,
    );
  }
}

class OrderCompletePage extends StatefulWidget {
  final String orderId;
  final String paymentMethod;
  final double totalAmount;

  const OrderCompletePage({
    super.key,
    required this.orderId,
    required this.paymentMethod,
    required this.totalAmount,
  });

  @override
  State<OrderCompletePage> createState() => _OrderCompletePageState();
}

class _OrderCompletePageState extends State<OrderCompletePage> {
  final CartService _cartService = CartService.instance;
  late final List<Map<String, dynamic>> _orderSummaryItems;

  @override
  void initState() {
    super.initState();
    // Capture current cart items snapshot before clearing
    _orderSummaryItems = _cartService.cartItems.map((item) {
      return {
        'name': item.product.name,
        'quantity': item.quantity,
        'temp': item.temperature,
        'sugar': item.sugarLevel,
        'totalPrice': item.totalPrice,
      };
    }).toList();
  }

  void _backToHome() {
    _cartService.clearCart();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Animated Checkmark Icon Badge
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.15),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLight,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Baristas are crafting your coffee right now ☕',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Live Order Status Progress Tracker Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Order Status', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                        Text('Est. 10 mins', style: TextStyle(color: AppTheme.primaryGold, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress Steps
                    Row(
                      children: [
                        _buildStatusStep('Received', true, true),
                        _buildStatusLine(true),
                        _buildStatusStep('Preparing', true, false),
                        _buildStatusLine(false),
                        _buildStatusStep('Ready', false, false),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Detailed Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.borderDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Receipt Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.textLight)),
                    const SizedBox(height: 12),
                    _buildReceiptRow('Order ID', widget.orderId),
                    _buildReceiptRow('Customer', _cartService.customerName),
                    _buildReceiptRow('Order Type', '${_cartService.orderType} (${_cartService.tableNumber})'),
                    _buildReceiptRow('Payment Method', widget.paymentMethod),
                    const Divider(color: AppTheme.borderDark, height: 24),

                    const Text('Items Ordered:', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                    const SizedBox(height: 8),

                    if (_orderSummaryItems.isEmpty)
                      const Text('Standard Coffee Sample Items', style: TextStyle(color: AppTheme.textMuted))
                    else
                      ..._orderSummaryItems.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item['quantity']}x ${item['name']} (${item['temp']})',
                                  style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
                                ),
                              ),
                              Text(
                                'Rp ${(item['totalPrice'] as double).toStringAsFixed(0)}',
                                style: const TextStyle(color: AppTheme.textLight, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),

                    const Divider(color: AppTheme.borderDark, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textLight)),
                        Text(
                          'Rp ${widget.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryGold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Back to Home / Order Again Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.storefront_outlined, color: Colors.black),
                  label: const Text('BACK TO HOME / ORDER AGAIN'),
                  onPressed: _backToHome,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13)),
          Text(value, style: const TextStyle(color: AppTheme.textLight, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStatusStep(String label, bool isDone, bool isFirst) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDone ? AppTheme.primaryGold : AppTheme.surfaceDark,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isDone ? Icons.check : Icons.circle_outlined,
            color: isDone ? Colors.black : AppTheme.textMuted,
            size: 16,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDone ? AppTheme.textLight : AppTheme.textMuted,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isActive ? AppTheme.primaryGold : AppTheme.borderDark,
      ),
    );
  }
}