import 'package:flutter_test/flutter_test.dart';
import 'package:pr12_3/models/product.dart';
import 'package:pr12_3/models/cart_item.dart';

void main() {
  group('Product Model Tests', () {
    test('Product should be initialized correctly', () {
      const product = Product(id: '1', name: 'Test Product', price: 10.0);
      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, 10.0);
    });

    test('Product equality should work', () {
      const p1 = Product(id: '1', name: 'A', price: 10.0);
      const p2 = Product(id: '1', name: 'A', price: 10.0);
      expect(p1, p2);
    });
  });

  group('CartItem Model Tests', () {
    test('CartItem should calculate total correctly', () {
      const product = Product(id: '1', name: 'Test', price: 10.0);
      final cartItem = CartItem(product: product, quantity: 2);
      expect(cartItem.total, 20.0);
    });

    test('CartItem quantity should default to 1', () {
      const product = Product(id: '1', name: 'Test', price: 10.0);
      final cartItem = CartItem(product: product);
      expect(cartItem.quantity, 1);
    });
  });
}
