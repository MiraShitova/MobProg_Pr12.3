import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'services/cart_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ProductListScreen(),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    _performHeavyComputation();
  }

  // FIX: Heavy computation moved out of build()
  Future<void> _performHeavyComputation() async {
    await compute(_heavyTask, 1000000);
  }

  static int _heavyTask(int count) {
    int result = 0;
    for (int i = 0; i < count; i++) {
      result += i;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Using const list to avoid recreating it on every build
    const products = [
      Product(id: '1', name: 'Laptop', price: 999.99),
      Product(id: '2', name: 'Smartphone', price: 499.99),
      Product(id: '3', name: 'Headphones', price: 199.99),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [
          CartIconWithBadge(), // FIX: Added const to the list literal
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductTile(product: product);
        },
      ),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  const CartIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: CircleAvatar(
            radius: 10,
            backgroundColor: Colors.red,
            child: Selector<CartService, int>(
              selector: (context, cart) => cart.items.length,
              builder: (context, count, child) => Text(
                '$count',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
      trailing: ElevatedButton(
        onPressed: () {
          Provider.of<CartService>(context, listen: false).addItem(product);
        },
        child: const Text('Add to Cart'),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartService>(
              builder: (context, cart, child) {
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      title: Text(item.product.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.total.toStringAsFixed(2)}'),
                    );
                  },
                );
              },
            ),
          ),
          const CartTotalSection(),
        ],
      ),
    );
  }
}

class CartTotalSection extends StatelessWidget {
  const CartTotalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Selector<CartService, double>(
        selector: (context, cart) => cart.totalPrice,
        builder: (context, totalPrice, child) => Text(
          'Total: \$${totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
