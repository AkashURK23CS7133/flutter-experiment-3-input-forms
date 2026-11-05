// Experiment 3: Add Interactivity to App – Input and Forms
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  final String name;
  final String category;
  final double price;
  final double rating;
  final String emoji;

  const Product({
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.emoji,
  });
}

const products = [
  Product(name: 'Laptop', category: 'Electronics', price: 75000, rating: 4.8, emoji: '💻'),
  Product(name: 'Smartphone', category: 'Electronics', price: 55000, rating: 4.7, emoji: '📱'),
  Product(name: 'Headphones', category: 'Electronics', price: 8000, rating: 4.3, emoji: '🎧'),
  Product(name: 'Smart Watch', category: 'Electronics', price: 22000, rating: 4.4, emoji: '⌚'),
  Product(name: 'Camera', category: 'Electronics', price: 45000, rating: 4.6, emoji: '📷'),
  Product(name: 'Tablet', category: 'Electronics', price: 35000, rating: 4.2, emoji: '📲'),
  Product(name: 'Backpack', category: 'Accessories', price: 2500, rating: 4.1, emoji: '🎒'),
  Product(name: 'Sunglasses', category: 'Fashion', price: 1800, rating: 4.0, emoji: '🕶️'),
  Product(name: 'Sneakers', category: 'Fashion', price: 6500, rating: 4.5, emoji: '👟'),
  Product(name: 'Keyboard', category: 'Accessories', price: 3500, rating: 4.4, emoji: '⌨️'),
  Product(name: 'Mouse', category: 'Accessories', price: 1800, rating: 4.2, emoji: '🖱️'),
  Product(name: 'Power Bank', category: 'Accessories', price: 2200, rating: 4.3, emoji: '🔋'),
];

const double kMaxPrice = 100000;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Experiment 3',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ProductPage(),
    );
  }
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  String category = 'All';
  double maxPrice = kMaxPrice;
  List<Product> filtered = products;
  int cartCount = 0;
  // Changing this key rebuilds the dropdown so "Clear Filters" resets it.
  int _dropdownKey = 0;

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      filtered = products.where((p) {
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesCategory = category == 'All' || p.category == category;
        final matchesPrice = p.price <= maxPrice;
        return matchesName && matchesCategory && matchesPrice;
      }).toList();
    });
  }

  void clearFilters() {
    searchController.clear();
    setState(() {
      category = 'All';
      maxPrice = kMaxPrice;
      filtered = products;
      _dropdownKey++;
    });
  }

  void addToCart(Product product) {
    setState(() => cartCount++);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          duration: const Duration(seconds: 1),
        ),
      );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Search & Filter'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Badge(
                label: Text('$cartCount'),
                isLabelVisible: cartCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.cyan.shade700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Find Your Product',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                Text('${products.length} products available',
                    style: const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                    labelText: 'Search Products',
                                    hintText: 'Search by product name...',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (_) => applyFilters(),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  key: ValueKey(_dropdownKey),
                                  initialValue: category,
                                  decoration: const InputDecoration(
                                    labelText: 'Filter by Category',
                                    prefixIcon: Icon(Icons.folder),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'All', child: Text('All')),
                                    DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                                    DropdownMenuItem(value: 'Accessories', child: Text('Accessories')),
                                    DropdownMenuItem(value: 'Fashion', child: Text('Fashion')),
                                  ],
                                  onChanged: (value) {
                                    category = value ?? 'All';
                                    applyFilters();
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Maximum Price'),
                                    Chip(label: Text('Rs.${maxPrice.toInt()}')),
                                  ],
                                ),
                                Slider(
                                  min: 0,
                                  max: kMaxPrice,
                                  divisions: 100,
                                  label: 'Rs.${maxPrice.toInt()}',
                                  value: maxPrice,
                                  onChanged: (value) {
                                    maxPrice = value;
                                    applyFilters();
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: applyFilters,
                                        icon: const Icon(Icons.tune),
                                        label: const Text('Apply Filters'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: clearFilters,
                                        icon: const Icon(Icons.clear),
                                        label: const Text('Clear Filters'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('${filtered.length} product(s) found',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      if (filtered.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('No products match your filters'),
                        ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return ProductCard(
                            product: product,
                            onAdd: () => addToCart(product),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable custom widget for product details.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(product.emoji, style: const TextStyle(fontSize: 36))),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.category, style: const TextStyle(fontSize: 12)),
            Text('Rs.${product.price.toInt()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(children: [
              const Icon(Icons.star, size: 14, color: Colors.amber),
              Text(' ${product.rating}', style: const TextStyle(fontSize: 12)),
            ]),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
