import 'package:flutter/material.dart';
import 'package:bugcoffee/home_page.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'barista@bugcoffee.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Stack(
        children: [
          // Background Gradient Orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryGold.withOpacity(0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentBronze.withOpacity(0.1),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.cardDark,
                        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.5), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGold.withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.coffee_rounded,
                        size: 54,
                        color: AppTheme.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Brand Name & Tagline
                    const Text(
                      'BugCoffee',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Freshly Brewed • Every Single Day',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Glassmorphic Input Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(color: AppTheme.borderDark),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Sign in to order your favorite coffee.',
                            style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 24),

                          // Email Input
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: AppTheme.textLight),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryGold),
                              labelText: 'Email Address / Username',
                              labelStyle: TextStyle(color: AppTheme.textMuted),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password Input
                          TextField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            style: const TextStyle(color: AppTheme.textLight),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primaryGold),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppTheme.textMuted,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(color: AppTheme.textMuted),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Forgot Password link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Password reset instructions sent to your email.'),
                                    backgroundColor: AppTheme.surfaceDark,
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: AppTheme.primaryGold, fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Sign In Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'SIGN IN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Continue as Guest Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _handleLogin,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderDark),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Explore Menu as Guest',
                                style: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
