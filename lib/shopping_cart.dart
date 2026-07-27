import 'package:flutter/material.dart';
import 'package:bugcoffee/pembayaran.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({super.key});

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final CartService _cartService = CartService.instance;
  final TextEditingController _voucherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
    if (_cartService.appliedVoucher.isNotEmpty) {
      _voucherController.text = _cartService.appliedVoucher;
    }
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    _voucherController.dispose();
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  void _applyVoucher() {
    final success = _cartService.applyVoucher(_voucherController.text);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voucher ${_cartService.appliedVoucher} applied! 20% discount applied.'),
          backgroundColor: Colors.green[800],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code. Try "BUGCOFFEE20" for 20% discount!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartService.cartItems;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cartItems.isNotEmpty)
            TextButton(
              onPressed: () {
                _cartService.clearCart();
              },
              child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.remove_shopping_cart_outlined, size: 64, color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Cart is Empty',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Looks like you haven\'t added any coffee yet.',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Explore Coffee Menu'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Cart Items List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.cardDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.borderDark),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isChecked,
                              activeColor: AppTheme.primaryGold,
                              checkColor: Colors.black,
                              onChanged: (_) => _cartService.toggleItemCheck(index),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 70,
                                  height: 70,
                                  color: AppTheme.surfaceDark,
                                  child: const Icon(Icons.coffee, color: AppTheme.primaryGold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppTheme.textLight,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.temperature} • Sugar ${item.sugarLevel}',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rp ${item.totalPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryGold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => _cartService.removeItem(index),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () => _cartService.updateQuantity(index, -1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.remove, size: 16, color: AppTheme.primaryGold),
                                        ),
                                      ),
                                      Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        onTap: () => _cartService.updateQuantity(index, 1),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          child: Icon(Icons.add, size: 16, color: AppTheme.primaryGold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Voucher Input & Order Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardDark,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, -4)),
                    ],
                    border: const Border(top: BorderSide(color: AppTheme.borderDark)),
                  ),
                  child: Column(
                    children: [
                      // Voucher Input Box
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _voucherController,
                              style: const TextStyle(color: AppTheme.textLight),
                              decoration: const InputDecoration(
                                hintText: 'Voucher Code (e.g. BUGCOFFEE20)',
                                hintStyle: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                                prefixIcon: Icon(Icons.local_offer_outlined, color: AppTheme.primaryGold, size: 20),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _applyVoucher,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Breakdown List
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal', style: TextStyle(color: AppTheme.textMuted)),
                          Text('Rp ${_cartService.subtotal.toStringAsFixed(0)}',
                              style: const TextStyle(color: AppTheme.textLight)),
                        ],
                      ),
                      if (_cartService.discountAmount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount (${_cartService.appliedVoucher})',
                                style: const TextStyle(color: Colors.greenAccent)),
                            Text('- Rp ${_cartService.discountAmount.toStringAsFixed(0)}',
                                style: const TextStyle(color: Colors.greenAccent)),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tax & Service (10%)', style: TextStyle(color: AppTheme.textMuted)),
                          Text('Rp ${_cartService.taxAndService.toStringAsFixed(0)}',
                              style: const TextStyle(color: AppTheme.textLight)),
                        ],
                      ),
                      const Divider(color: AppTheme.borderDark, height: 20),

                      // Total & Checkout
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Grand Total', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                              Text(
                                'Rp ${_cartService.grandTotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryGold,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.arrow_forward, color: Colors.black),
                            label: const Text('Proceed to Payment'),
                            onPressed: _cartService.subtotal <= 0
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PembayaranScreen()),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
