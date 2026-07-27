import 'package:flutter/material.dart';
import 'package:bugcoffee/order.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class KirimUangApp extends StatelessWidget {
  const KirimUangApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const KirimUangScreen();
  }
}

class KirimUangScreen extends StatefulWidget {
  const KirimUangScreen({super.key});

  @override
  State<KirimUangScreen> createState() => _KirimUangScreenState();
}

class _KirimUangScreenState extends State<KirimUangScreen> {
  final CartService _cartService = CartService.instance;
  final TextEditingController _cashInputController = TextEditingController();
  final String _orderId = 'BUG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

  double _cashTendered = 0.0;

  @override
  void initState() {
    super.initState();
    _cashTendered = _cartService.grandTotal;
    _cashInputController.text = _cartService.grandTotal.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _cashInputController.dispose();
    super.dispose();
  }

  double get _changeAmount => _cashTendered - _cartService.grandTotal;

  void _selectNominal(double amount) {
    setState(() {
      _cashTendered = amount;
      _cashInputController.text = amount.toStringAsFixed(0);
    });
  }

  void _confirmCashPayment() {
    if (_cashTendered < _cartService.grandTotal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cash tendered cannot be less than total amount!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OrderCompletePage(
          orderId: _orderId,
          paymentMethod: 'Cash / Counter',
          totalAmount: _cartService.grandTotal,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double total = _cartService.grandTotal;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Cash Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Payable Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGold.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  const Text('Total Amount Due', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    'Rp ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGold,
                    ),
                  ),
                  const Divider(color: AppTheme.borderDark, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Customer: ${_cartService.customerName}', style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
                      Text('Mode: ${_cartService.orderType}', style: const TextStyle(color: AppTheme.accentBronze, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cash Received Section
            const Text('Cash Tendered (Uang Tunai)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
            const SizedBox(height: 12),

            // Custom Cash Input Field
            TextField(
              controller: _cashInputController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppTheme.textLight, fontSize: 20, fontWeight: FontWeight.bold),
              onChanged: (val) {
                setState(() {
                  _cashTendered = double.tryParse(val) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: const TextStyle(color: AppTheme.primaryGold, fontSize: 20, fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                  onPressed: () {
                    _cashInputController.clear();
                    setState(() => _cashTendered = 0.0);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Quick Nominal Chips
            const Text('Quick Cash Select:', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildQuickChip('Exact (Rp ${total.toStringAsFixed(0)})', total),
                _buildQuickChip('Rp 50,000', 50000),
                _buildQuickChip('Rp 100,000', 100000),
                _buildQuickChip('Rp 200,000', 200000),
              ],
            ),
            const SizedBox(height: 28),

            // Change Amount Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _changeAmount >= 0 ? AppTheme.surfaceDark : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _changeAmount >= 0 ? AppTheme.borderDark : Colors.redAccent,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Change (Kembalian)', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                      SizedBox(height: 4),
                      Text('Calculated Change', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                    ],
                  ),
                  Text(
                    _changeAmount >= 0 ? 'Rp ${_changeAmount.toStringAsFixed(0)}' : 'Insufficient Cash',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _changeAmount >= 0 ? Colors.greenAccent : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Confirm Cash Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.black),
                label: const Text('CONFIRM CASH PAYMENT'),
                onPressed: _confirmCashPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, double amount) {
    final isSelected = _cashTendered == amount;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primaryGold,
      backgroundColor: AppTheme.cardDark,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppTheme.textLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => _selectNominal(amount),
    );
  }
}
