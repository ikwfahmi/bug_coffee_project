import 'package:flutter/material.dart';
import 'package:bugcoffee/cash.dart';
import 'package:bugcoffee/qris.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class PembayaranScreen extends StatefulWidget {
  const PembayaranScreen({super.key});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final CartService _cartService = CartService.instance;
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _tableController = TextEditingController(text: 'T-08');

  String _selectedMethod = 'QRIS'; // 'QRIS', 'CASH', 'CARD', 'VA'
  String _orderType = 'Dine In'; // 'Dine In', 'Takeaway'

  @override
  void dispose() {
    _nameController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  void _proceedToPayment() {
    _cartService.setCustomerDetails(
      name: _nameController.text,
      type: _orderType,
      table: _tableController.text,
    );

    if (_selectedMethod == 'QRIS') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Qris()),
      );
    } else if (_selectedMethod == 'CASH') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => KirimUangScreen()),
      );
    } else {
      // Direct QRIS or default cash flow
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Qris()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Checkout & Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.cardDark,
                          AppTheme.surfaceDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryGold.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Payment',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rp ${_cartService.grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        const Divider(color: AppTheme.borderDark, height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_cartService.totalItemCount} Items Selected',
                              style: const TextStyle(color: AppTheme.textLight, fontSize: 13),
                            ),
                            Text(
                              _cartService.appliedVoucher.isNotEmpty
                                  ? 'Voucher ${_cartService.appliedVoucher} Applied'
                                  : 'No Voucher Applied',
                              style: TextStyle(
                                color: _cartService.appliedVoucher.isNotEmpty
                                    ? Colors.greenAccent
                                    : AppTheme.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Customer Details Form
                  const Text('Order Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                  const SizedBox(height: 12),

                  // Order Type Selection
                  Row(
                    children: ['Dine In', 'Takeaway'].map((type) {
                      final isSel = _orderType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _orderType = type),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSel ? AppTheme.primaryGold : AppTheme.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSel ? AppTheme.primaryGold : AppTheme.borderDark),
                            ),
                            child: Center(
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSel ? Colors.black : AppTheme.textLight,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(color: AppTheme.textLight),
                          decoration: const InputDecoration(
                            labelText: 'Customer Name',
                            prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryGold),
                          ),
                        ),
                      ),
                      if (_orderType == 'Dine In') ...[
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _tableController,
                            style: const TextStyle(color: AppTheme.textLight),
                            decoration: const InputDecoration(
                              labelText: 'Table No.',
                              prefixIcon: Icon(Icons.table_restaurant_outlined, color: AppTheme.primaryGold),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Select Payment Method Section
                  const Text(
                    'Select Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight),
                  ),
                  const SizedBox(height: 14),

                  // Option 1: QRIS / E-Wallet
                  _buildPaymentOptionCard(
                    id: 'QRIS',
                    title: 'QRIS / E-Wallet',
                    subtitle: 'Instant QR Scan (GoPay, OVO, ShopeePay, Dana)',
                    icon: Icons.qr_code_2_rounded,
                    badgeText: 'INSTANT & FAST',
                  ),

                  // Option 2: Cash / Cashier
                  _buildPaymentOptionCard(
                    id: 'CASH',
                    title: 'Cash / Pay at Counter',
                    subtitle: 'Pay directly to the cashier or COD',
                    icon: Icons.payments_outlined,
                  ),

                  // Option 3: Credit Card
                  _buildPaymentOptionCard(
                    id: 'CARD',
                    title: 'Credit / Debit Card',
                    subtitle: 'Visa, MasterCard, JCB',
                    icon: Icons.credit_card_outlined,
                  ),

                  // Option 4: Bank Transfer / VA
                  _buildPaymentOptionCard(
                    id: 'VA',
                    title: 'Virtual Account',
                    subtitle: 'BCA, Mandiri, BNI, BRI',
                    icon: Icons.account_balance_outlined,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: const Border(top: BorderSide(color: AppTheme.borderDark)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _selectedMethod == 'QRIS'
                          ? 'PAY WITH QRIS'
                          : (_selectedMethod == 'CASH' ? 'PAY WITH CASH' : 'CONFIRM PAYMENT'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptionCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    String? badgeText,
  }) {
    final isSel = _selectedMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSel ? AppTheme.surfaceDark : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSel ? AppTheme.primaryGold : AppTheme.borderDark,
            width: isSel ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSel ? AppTheme.primaryGold : AppTheme.borderDark,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSel ? Colors.black : AppTheme.primaryGold, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textLight,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentBronze,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSel ? AppTheme.primaryGold : AppTheme.textMuted, width: 2),
              ),
              child: isSel
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryGold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
