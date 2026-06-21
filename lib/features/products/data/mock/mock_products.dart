import 'package:nike_ecommerce/features/products/domain/models/product.dart';

final List<Product> mockProducts = [
  const Product(
    id: 'prod_001',
    name: "Nike Air Force 1 '07",
    description: "The radiance lives on in the Nike Air Force 1 '07, the b-ball icon that puts a fresh spin on what you know best: crisp leather, bold colors and the perfect amount of flash to make you shine.",
    price: 115.00,
    category: 'Lifestyle',
    sizes: [40, 41, 42, 43, 44, 45],
    imageUrl: 'placeholder',
    rating: 4.8,
    reviewCount: 3420,
    stock: 150,
    isFeatured: true,
  ),
  const Product(
    id: 'prod_002',
    name: 'Nike Air Max Pulse',
    description: "The Air Max Pulse pulls inspiration from the London music scene, bringing an underground touch to the iconic Air Max line. Its textile-wrapped midsole and vacuum-sealed accents keep 'em looking fresh and clean.",
    price: 150.00,
    category: 'Lifestyle',
    sizes: [39, 40, 41, 42, 43],
    imageUrl: 'placeholder',
    rating: 4.6,
    reviewCount: 1205,
    stock: 80,
    isFeatured: true,
  ),
  const Product(
    id: 'prod_003',
    name: 'Nike Pegasus 41',
    description: "Springy ride for every run, the Pegasus' familiar, just-for-you feel returns to help you accomplish your goals. This version has the same responsiveness and neutral support you love, but with improved comfort in those sensitive areas of your foot.",
    price: 130.00,
    category: 'Running',
    sizes: [40, 41, 42, 43, 44, 45, 46],
    imageUrl: 'placeholder',
    rating: 4.9,
    reviewCount: 2540,
    stock: 200,
    isFeatured: false,
  ),
  const Product(
    id: 'prod_004',
    name: 'Nike LeBron XXI',
    description: "The LeBron XXI is built for basketball's next generation. It has a cabling system that works with Zoom Air cushioning and a light, low-to-the-ground design, giving you fluid, explosive performance without excess weight.",
    price: 200.00,
    category: 'Basketball',
    sizes: [41, 42, 43, 44, 45, 46, 47],
    imageUrl: 'placeholder',
    rating: 4.7,
    reviewCount: 890,
    stock: 50,
    isFeatured: true,
  ),
  const Product(
    id: 'prod_005',
    name: 'Nike Dunk Low Retro',
    description: "Created for the hardwood but taken to the streets, the '80s b-ball icon returns with perfectly shined overlays and classic team colors. With its iconic hoops design, the Nike Dunk Low channels '80s vintage back onto the streets.",
    price: 115.00,
    category: 'Lifestyle',
    sizes: [38, 39, 40, 41, 42],
    imageUrl: 'placeholder',
    rating: 4.8,
    reviewCount: 5600,
    stock: 0,
    isFeatured: false,
  ),
];

// Helper method to get the list of maps for Firestore upload
List<Map<String, dynamic>> getMockProductsJson() {
  return mockProducts.map((p) => p.toJson()).toList();
}
