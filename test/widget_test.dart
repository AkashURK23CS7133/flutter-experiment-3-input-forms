import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exp03_input_forms/main.dart';

void main() {
  setUp(() {});

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 4000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MyApp());
  }

  testWidgets('Shows all 12 products initially', (tester) async {
    await pumpApp(tester);
    expect(find.text('12 product(s) found'), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(12));
  });

  testWidgets('Search by name filters the list', (tester) async {
    await pumpApp(tester);
    await tester.enterText(find.byType(TextFormField), 'su');
    await tester.pump();
    expect(find.text('1 product(s) found'), findsOneWidget);
    expect(find.text('Sunglasses'), findsOneWidget);
  });

  testWidgets('Category dropdown filters the list', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fashion').last);
    await tester.pumpAndSettle();
    expect(find.text('2 product(s) found'), findsOneWidget);
  });

  testWidgets('Slider max price and Clear Filters', (tester) async {
    await pumpApp(tester);
    final slider = tester.widget<Slider>(find.byType(Slider));
    slider.onChanged!(45000);
    await tester.pump();
    expect(find.text('10 product(s) found'), findsOneWidget);

    await tester.tap(find.text('Clear Filters'));
    await tester.pump();
    expect(find.text('12 product(s) found'), findsOneWidget);
  });

  testWidgets('Add to Cart shows SnackBar', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Add to Cart').first);
    await tester.pump();
    expect(find.text('Laptop added to cart'), findsOneWidget);
  });
}
