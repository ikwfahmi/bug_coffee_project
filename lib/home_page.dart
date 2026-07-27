import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bugcoffee/models/product.dart';
import 'package:bugcoffee/services/cart_service.dart';
import 'package:bugcoffee/shopping_cart.dart';
import 'package:bugcoffee/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CartService _cartService = CartService.instance;
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  final List<Map<String, String>> _banners = [
    {
      'title': 'Coffee of the Day',
      'subtitle': 'Get 20% OFF Caramel Macchiato with code BUGCOFFEE20',
      'code': 'BUGCOFFEE20',
      'bgUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'New Matcha Season',
      'subtitle': 'Authentic Uji Green Tea with Creamy Milk',
      'code': 'MATCHA',
      'bgUrl': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Morning Bakery Combo',
      'subtitle': 'Pair your Coffee Latte with a Butter Croissant',
      'code': 'MORNING',
      'bgUrl': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=800&q=80',
    },
  ];

  final List<String> _categories = ['All', 'Coffee', 'Non-Coffee', 'Food', 'Bakery'];

  @override
  void initState() {
    super.initState();
    _startBannerAutoPlay();
    _cartService.addListener(_onCartUpdated);
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _cartService.removeListener(_onCartUpdated);
    super.dispose();
  }

  void _onCartUpdated() {
    if (mounted) setState(() {});
  }

  void _startBannerAutoPlay() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (_currentBannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  List<Product> get _filteredProducts {
    return sampleProducts.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _showProductDetailsModal(Product product) {
    String selectedTemp = 'Ice';
    String selectedSugar = '100%';
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Header & Image
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.imageUrl,
                          width: 85,
                          height: 85,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 85,
                            height: 85,
                            color: AppTheme.surfaceDark,
                            child: const Icon(Icons.coffee, color: AppTheme.primaryGold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.category,
                              style: const TextStyle(color: AppTheme.primaryGold, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Rp ${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentBronze,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Temperature Option if drink
                  if (product.category == 'Coffee' || product.category == 'Non-Coffee') ...[
                    const Text('Temperature', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Ice', 'Hot'].map((temp) {
                        final isSel = selectedTemp == temp;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ChoiceChip(
                            label: Text(temp),
                            selected: isSel,
                            onSelected: (selected) {
                              if (selected) setModalState(() => selectedTemp = temp);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    const Text('Sugar Level', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textLight)),
                    const SizedBox(height: 8),
                    Row(
                      children: ['100%', '50%', '0%'].map((sugar) {
                        final isSel = selectedSugar == sugar;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: ChoiceChip(
                            label: Text(sugar),
                            selected: isSel,
                            onSelected: (selected) {
                              if (selected) setModalState(() => selectedSugar = sugar);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Quantity and Add Button Row
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, color: AppTheme.primaryGold),
                              onPressed: () {
                                if (quantity > 1) {
                                  setModalState(() => quantity--);
                                }
                              },
                            ),
                            Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, color: AppTheme.primaryGold),
                              onPressed: () {
                                setModalState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
                          label: Text('Add Rp ${(product.price * quantity).toStringAsFixed(0)}'),
                          onPressed: () {
                            _cartService.addToCart(
                              product,
                              temp: selectedTemp,
                              sugar: selectedSugar,
                              quantity: quantity,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added ${product.name} to Cart'),
                                backgroundColor: AppTheme.surfaceDark,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('BugCoffee'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryGold),
            onPressed: () {},
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: AppTheme.primaryGold),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
                  );
                },
              ),
              if (_cartService.totalItemCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.accentBronze,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${_cartService.totalItemCount}',
                      style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Top Welcome & Search
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Find the best coffee',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'for your day ☕',
                          style: TextStyle(fontSize: 16, color: AppTheme.textMuted),
                        ),
                        const SizedBox(height: 16),

                        // Search Bar
                        TextField(
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search coffee, tea, food...',
                            prefixIcon: const Icon(Icons.search, color: AppTheme.primaryGold),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: AppTheme.textMuted),
                                    onPressed: () => setState(() => _searchQuery = ''),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // Hero Promo Banner Carousel
                if (_searchQuery.isEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 155,
                          child: PageView.builder(
                            controller: _bannerController,
                            onPageChanged: (index) {
                              setState(() => _currentBannerIndex = index);
                            },
                            itemCount: _banners.length,
                            itemBuilder: (context, index) {
                              final b = _banners[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                    image: NetworkImage(b['bgUrl']!),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.65),
                                      BlendMode.darken,
                                    ),
                                  ),
                                  border: Border.all(color: AppTheme.primaryGold.withOpacity(0.4)),
                                ),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryGold,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'SPECIAL PROMO',
                                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      b['title']!,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      b['subtitle']!,
                                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Carousel Dots Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_banners.length, (idx) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              height: 6,
                              width: _currentBannerIndex == idx ? 20 : 6,
                              decoration: BoxDecoration(
                                color: _currentBannerIndex == idx ? AppTheme.primaryGold : AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                // Category Chips Selector
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            selectedColor: AppTheme.primaryGold,
                            backgroundColor: AppTheme.cardDark,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.black : AppTheme.textLight,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Product Grid
                _filteredProducts.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('No products found', style: TextStyle(color: AppTheme.textMuted)),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = _filteredProducts[index];
                              return _buildProductCard(product);
                            },
                            childCount: _filteredProducts.length,
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),

          // Floating Bottom Cart Action Bar
          if (_cartService.totalItemCount > 0)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, -4)),
                ],
                border: const Border(top: BorderSide(color: AppTheme.borderDark)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total ${_cartService.totalItemCount} Items',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                      Text(
                        'Rp ${_cartService.grandTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryGold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShoppingCartScreen()),
                      );
                    },
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                    label: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => _showProductDetailsModal(product),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Rating Badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: AppTheme.surfaceDark,
                      child: const Center(child: Icon(Icons.coffee, color: AppTheme.primaryGold)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                if (product.isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentBronze,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'BEST',
                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rp ${(product.price / 1000).toStringAsFixed(0)}k',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryGold,
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryGold,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.add, color: Colors.black, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
