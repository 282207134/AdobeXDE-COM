import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nordic_store/data/catalog.dart';
import 'package:nordic_store/state/store_controller.dart';
import 'package:nordic_store/ui/checkout_screens.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('quantity, voucher and checkout totals remain consistent', () {
    final c = StoreController();
    c.cart.clear();
    c.addToCart('shirt');
    c.addToCart('shirt');
    expect(c.subtotal, 300);
    expect(c.applyVoucher('welcome10'), isTrue);
    expect(c.total, 320);
    c.changeQuantity('shirt', -1);
    expect(c.total, 185);
    c.changeQuantity('shirt', -1);
    expect(c.cart, isEmpty);
    expect(c.total, 0);
    c.addToCart('speaker');
    c.placeOrder();
    expect(c.placedOrders, 1);
    expect(c.cart, isEmpty);
    expect(c.voucherApplied, isFalse);
    c.dispose();
  });

  test(
    'saved state restores cart, appearance, favorites and masked card',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final c = StoreController(preferences: prefs);
      c.toggleTheme();
      c.addToCart('shirt');
      c.toggleWishlist('shirt');
      c.addCard(const SavedCard('Demo User', '1234', '12/29'));
      final restored = StoreController(preferences: prefs);
      expect(restored.dark, isTrue);
      expect(restored.cart['shirt'], 1);
      expect(restored.wishlist.contains('shirt'), isTrue);
      expect(restored.cards.last.lastFour, '1234');
      final raw = prefs.getString('store.v1')!;
      expect(raw.contains('cvv'), isFalse);
      expect(raw.contains('cardNumber'), isFalse);
      c.dispose();
      restored.dispose();
    },
  );

  test('card form rejects malformed and expired input', () {
    expect(validateCardNumber('123'), isNotNull);
    expect(validateCardNumber('abcd efgh ijkl mnop'), isNotNull);
    expect(validateCardNumber('5623 4587 9658 4521'), isNull);
    expect(validateExpiry('13/29'), isNotNull);
    expect(validateExpiry('01/20'), isNotNull);
    expect(validateExpiry('12/99'), isNull);
  });
}
