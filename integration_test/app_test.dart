import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nordic_store/app.dart';
import 'package:nordic_store/core/routes.dart';
import 'package:nordic_store/state/store_controller.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('capture every screen in both themes on Android', (tester) async {
    final c = StoreController();
    await tester.pumpWidget(
      StoreApp(controller: c, initialScreen: AppScreen.home),
    );
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    for (final dark in [false, true]) {
      c.dark = dark;
      for (final screen in AppScreen.values) {
        await tester.pumpWidget(
          StoreApp(
            key: ValueKey('$screen-$dark'),
            controller: c,
            initialScreen: screen,
          ),
        );
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 300));
        expect(tester.takeException(), isNull, reason: screen.name);
        await binding.takeScreenshot(
          '${dark ? 'dark' : 'light'}-${screen.name}',
        );
      }
    }
    await tester.pumpWidget(
      StoreApp(key: const ValueKey('journey'), controller: c),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('auth_submit')));
    await tester.tap(find.byKey(const Key('auth_submit')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav_search')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('search_input')), 'Nike');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nike Dri-FIT Long Sleeve'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    expect(c.cart['shirt'], 1);
    await tester.tap(find.byTooltip('Open cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('checkout_button')));
    await tester.pumpAndSettle();
    for (int i = 0; i < 3; i++) {
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('PAY NOW'));
    await tester.pumpAndSettle();
    expect(find.text('Order Placed!'), findsOneWidget);
    expect(c.placedOrders, 1);
    await binding.takeScreenshot('journey-order-success');
  });
}
