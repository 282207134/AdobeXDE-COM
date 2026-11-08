import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nordic_store/app.dart';
import 'package:nordic_store/core/routes.dart';
import 'package:nordic_store/state/store_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final loader = FontLoader('Quicksand')
      ..addFont(rootBundle.load('assets/fonts/Quicksand.ttf'));
    await loader.load();
  });

  for (final dark in [false, true]) {
    testWidgets(
      'all screens fit a compact phone in ${dark ? 'dark' : 'light'} theme',
      (tester) async {
        tester.view.physicalSize = const Size(375, 667);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final c = StoreController()..dark = dark;
        for (final screen in AppScreen.values) {
          await tester.pumpWidget(
            StoreApp(
              key: ValueKey('$screen-$dark'),
              controller: c,
              initialScreen: screen,
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull, reason: screen.name);
        }
        await tester.pumpWidget(const SizedBox.shrink());
        c.dispose();
      },
    );
  }

  testWidgets(
    'login, search and purchase demo complete through visible controls',
    (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final c = StoreController();
      await tester.pumpWidget(StoreApp(controller: c));
      await tester.ensureVisible(find.byKey(const Key('auth_submit')));
      await tester.tap(find.byKey(const Key('auth_submit')));
      await tester.pumpAndSettle();
      expect(find.text('Best Selling'), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav_search')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('search_input')), 'Nike');
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
      expect(c.cart, isEmpty);
      expect(c.placedOrders, 1);
    },
  );
}
