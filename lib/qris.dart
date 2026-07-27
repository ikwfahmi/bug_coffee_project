import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bugcoffee/order.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class Qris extends StatefulWidget {
  const Qris({super.key});

  @override
  State<Qris> createState() => _QrisState();
}

class _QrisState extends State<Qris> {
  final CartService _cartService = CartService.instance;
  late Timer _timer;
  int _remainingSeconds = 900; // 15 minutes
  final String _orderId = 'BUG-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int mins = _remainingSeconds ~/ 60;
    int secs = _remainingSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _confirmPayment() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => OrderCompletePage(
          orderId: _orderId,
          paymentMethod: 'QRIS / E-Wallet',
          totalAmount: _cartService.grandTotal,
        ),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Scan QRIS Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryGold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Timer Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryGold.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, color: AppTheme.accentBronze, size: 20),
                  const SizedBox(width: 8),
                  const Text('Payment expires in: ', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                  Text(
                    _formattedTime,
                    style: const TextStyle(color: AppTheme.primaryGold, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main QR Code Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGold.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // QRIS Header Logos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'QRIS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFC62828),
                          letterSpacing: 1.5,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
                            child: const Text('GPN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                          ),
                          const SizedBox(width: 6),
                          const Text('GOPAY • OVO • DANA', style: TextStyle(color: Colors.black54, fontSize: 9, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 1),

                  Text(
                    'BugCoffee Indonesia',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NMID: ID10293847561',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),

                  // Custom Generated QR Pattern Box
                  Container(
                    width: 210,
                    height: 210,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Custom Grid Pattern simulating QR Code
                        CustomPaint(
                          size: const Size(180, 180),
                          painter: _QrPainter(),
                        ),
                        // Center Logo Badge
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.bgDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryGold, width: 2),
                          ),
                          child: const Icon(Icons.coffee, color: AppTheme.primaryGold, size: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Total Amount Inside QR Box
                  Text(
                    'Rp ${_cartService.grandTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order ID: $_orderId',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order ID Copy Button
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _orderId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order ID copied to clipboard!')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.borderDark),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.copy, color: AppTheme.primaryGold, size: 18),
                    const SizedBox(width: 8),
                    Text('Copy Order ID: $_orderId', style: const TextStyle(color: AppTheme.textLight, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Instructions Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('How to Pay with QRIS:', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                  SizedBox(height: 10),
                  Text('1. Open your E-Wallet app (GoPay, OVO, ShopeePay, Dana, BCA Mobile).', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  SizedBox(height: 6),
                  Text('2. Select Scan / QRIS menu and point your camera to this QR code.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  SizedBox(height: 6),
                  Text('3. Verify the recipient name is "BugCoffee Indonesia" and amount matches.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  SizedBox(height: 6),
                  Text('4. Enter your PIN to complete the transaction.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // I Have Paid Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline, color: Colors.black),
                label: const Text('I HAVE COMPLETED PAYMENT'),
                onPressed: _confirmPayment,
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
}

// Custom QR Painter to draw clean QR pattern
class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Corner Markers
    _drawFinderPattern(canvas, paint, const Offset(0, 0));
    _drawFinderPattern(canvas, paint, Offset(size.width - 45, 0));
    _drawFinderPattern(canvas, paint, Offset(0, size.height - 45));

    // Random Data Matrix simulation
    final double step = 9.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        // Skip corner finder areas
        if ((x < 50 && y < 50) || (x > size.width - 50 && y < 50) || (x < 50 && y > size.height - 50)) {
          continue;
        }
        // Skip center logo area
        if (x > size.width / 2 - 25 && x < size.width / 2 + 25 && y > size.height / 2 - 25 && y < size.height / 2 + 25) {
          continue;
        }
        if ((x.toInt() * 7 + y.toInt() * 13) % 3 == 0) {
          canvas.drawRect(Rect.fromLTWH(x, y, step - 1.5, step - 1.5), paint);
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, Paint paint, Offset offset) {
    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, 45, 45), paint);
    canvas.drawRect(
        Rect.fromLTWH(offset.dx + 6, offset.dy + 6, 33, 33), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(offset.dx + 12, offset.dy + 12, 21, 21), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
