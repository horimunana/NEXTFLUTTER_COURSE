import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/core/stores/recipe_store.dart';
import 'package:recipe_app/main.dart';

void main() {
  setUp(() {
    RecipeStore.instance.clear();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const RecipeApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('App launches and shows the home screen', (tester) async {
    await pumpApp(tester);

    expect(find.text('Pizza Recipes'), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);
  });

  testWidgets('Search filters recipes', (tester) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField).first, 'Diavola');
    await tester.pump();

    expect(find.text('Diavola'), findsWidgets);
  });

  testWidgets('Toggle theme switches to dark', (tester) async {
    await pumpApp(tester);

    expect(
      Theme.of(tester.element(find.text('Pizza Recipes'))).brightness,
      Brightness.light,
    );

    await tester.tap(find.byIcon(Icons.dark_mode_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      Theme.of(tester.element(find.text('Pizza Recipes'))).brightness,
      Brightness.dark,
    );
  });
}
