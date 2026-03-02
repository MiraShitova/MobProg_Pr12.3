import 'package:flutter_test/flutter_test.dart';
import 'package:pr12_3/models/product.dart';
import 'package:pr12_3/services/cart_service.dart';

void main() {
  late CartService cartService;
  late Product product;

  setUp(() {
    cartService = CartService();
    product = Product(id: '1', name: 'Test Product', price: 10.0);
  });

  group('CartService Tests', () {
    test('Initial cart should be empty', () {
      expect(cartService.items.length, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('Adding product should increase item count', () {
      cartService.addItem(product);
      expect(cartService.items.length, 1);
      expect(cartService.items[0].product, product);
      expect(cartService.items[0].quantity, 1);
    });

    test('Adding same product should increase quantity', () {
      cartService.addItem(product);
      cartService.addItem(product);
      expect(cartService.items.length, 1);
      expect(cartService.items[0].quantity, 2);
    });

    test('Removing item should update cart', () {
      cartService.addItem(product);
      cartService.removeItem(product.id);
      expect(cartService.items.length, 0);
    });

    test('TotalPrice should calculate correctly', () {
      cartService.addItem(product);
      cartService.addItem(Product(id: '2', name: 'Other', price: 20.0));
      expect(cartService.totalPrice, 30.0);
    });

    test('Clear should empty the cart', () {
      cartService.addItem(product);
      cartService.clear();
      expect(cartService.items.length, 0);
    });
  });
}
