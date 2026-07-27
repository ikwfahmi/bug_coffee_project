class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final bool isBestSeller;
  final bool isNew;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    this.isBestSeller = false,
    this.isNew = false,
  });
}

class CartItem {
  final Product product;
  int quantity;
  String temperature; // 'Hot' or 'Ice'
  String sugarLevel; // '0%', '50%', '100%'
  bool isChecked;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.temperature = 'Ice',
    this.sugarLevel = '100%',
    this.isChecked = true,
  });

  double get totalPrice => product.price * quantity;
}

final List<Product> sampleProducts = [
  // COFFEE
  const Product(
    id: 'c1',
    name: 'Coffee Latte',
    category: 'Coffee',
    description: 'Smooth espresso blended with silky steamed milk and a light layer of foam.',
    price: 18000,
    rating: 4.8,
    reviewsCount: 142,
    imageUrl: 'https://images.unsplash.com/photo-1570968915860-54d5c301fa9f?auto=format&fit=crop&w=600&q=80',
    isBestSeller: true,
  ),
  const Product(
    id: 'c2',
    name: 'Espresso Double',
    category: 'Coffee',
    description: 'Rich, intense, and aromatic double shot of authentic Arabica coffee.',
    price: 15000,
    rating: 4.6,
    reviewsCount: 89,
    imageUrl: 'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?auto=format&fit=crop&w=600&q=80',
  ),
  const Product(
    id: 'c3',
    name: 'Caramel Macchiato',
    category: 'Coffee',
    description: 'Freshly steamed milk with vanilla-flavored syrup marked with espresso and drizzled with caramel.',
    price: 24000,
    rating: 4.9,
    reviewsCount: 215,
    imageUrl: 'https://images.unsplash.com/photo-1485808191679-5f86510681a2?auto=format&fit=crop&w=600&q=80',
    isBestSeller: true,
  ),
  const Product(
    id: 'c4',
    name: 'Americano',
    category: 'Coffee',
    description: 'Espresso shots topped with hot water create a light layer of crema.',
    price: 16000,
    rating: 4.5,
    reviewsCount: 97,
    imageUrl: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=600&q=80',
  ),

  // NON-COFFEE
  const Product(
    id: 'nc1',
    name: 'Matcha Latte',
    category: 'Non-Coffee',
    description: 'Premium Uji green tea matcha powder whisked with creamy fresh milk.',
    price: 23000,
    rating: 4.8,
    reviewsCount: 168,
    imageUrl: 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=600&q=80',
    isBestSeller: true,
  ),
  const Product(
    id: 'nc2',
    name: 'Red Velvet Latte',
    category: 'Non-Coffee',
    description: 'Indulgent red velvet cake flavor combined with velvety smooth milk.',
    price: 23000,
    rating: 4.7,
    reviewsCount: 112,
    imageUrl: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=600&q=80',
    isNew: true,
  ),
  const Product(
    id: 'nc3',
    name: 'Signature Chocolate',
    category: 'Non-Coffee',
    description: 'Rich dark Belgian cocoa steamed with creamy milk and topped with cocoa powder.',
    price: 22000,
    rating: 4.9,
    reviewsCount: 190,
    imageUrl: 'https://images.unsplash.com/photo-1542990253-0d0f5be5f0ed?auto=format&fit=crop&w=600&q=80',
  ),

  // FOOD
  const Product(
    id: 'f1',
    name: 'Rice Bowl Teriyaki',
    category: 'Food',
    description: 'Crispy chicken coated in sweet savory teriyaki sauce served over warm jasmine rice.',
    price: 25000,
    rating: 4.7,
    reviewsCount: 130,
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=600&q=80',
    isBestSeller: true,
  ),
  const Product(
    id: 'f2',
    name: 'Nasi Goreng Special',
    category: 'Food',
    description: 'Indonesian fried rice with sunny-side up egg, chicken, and signature spices.',
    price: 22000,
    rating: 4.8,
    reviewsCount: 175,
    imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=600&q=80',
  ),

  // BAKERY
  const Product(
    id: 'b1',
    name: 'Butter Croissant',
    category: 'Bakery',
    description: 'Flaky, buttery French pastry freshly baked every morning.',
    price: 15000,
    rating: 4.9,
    reviewsCount: 155,
    imageUrl: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=600&q=80',
    isNew: true,
  ),
  const Product(
    id: 'b2',
    name: 'Fudgy Brownies',
    category: 'Bakery',
    description: 'Decadent dark chocolate brownie with crispy top and gooey center.',
    price: 18000,
    rating: 4.8,
    reviewsCount: 98,
    imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=600&q=80',
  ),
];
