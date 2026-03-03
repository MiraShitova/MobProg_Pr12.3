import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pr12_3/main.dart';
import 'package:pr12_3/services/cart_service.dart';

void main() {
  testWidgets('E-commerce app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => CartService(),
        child: const MyApp(),
      ),
    );

    // Verify that we start with 0 items in cart badge
    expect(find.text('0'), findsOneWidget);

    // Find the 'Add to Cart' button and tap it
    final addButton = find.text('Add to Cart').first;
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify that our cart badge has incremented to 1
    expect(find.text('1'), findsOneWidget);
  });
}
