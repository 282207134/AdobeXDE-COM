import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/catalog.dart';

class StoreController extends ChangeNotifier {
  StoreController({SharedPreferences? preferences})
    : _preferences = preferences {
    final raw = preferences?.getString('store.v1');
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        dark = j['dark'] == true;
        name = j['name'] as String? ?? name;
        email = j['email'] as String? ?? email;
        cart = Map<String, int>.from(j['cart'] as Map);
        wishlist = Set<String>.from(j['wishlist'] as List);
        addresses = (j['addresses'] as List)
            .map((a) => SavedAddress.fromJson(a))
            .toList();
        cards = (j['cards'] as List).map((c) => SavedCard.fromJson(c)).toList();
        placedOrders = j['orders'] as int? ?? 0;
      } catch (_) {
        // A damaged local cache must not prevent the app from opening.
      }
    }
  }
  final SharedPreferences? _preferences;
  bool dark = false, voucherApplied = false;
  String name = 'David Spade', email = 'iamdavid@gmail.com';
  String delivery = 'Standard Delivery';
  SavedAddress? checkoutAddress;
  SavedCard? checkoutCard;
  int selectedAddress = 0, selectedCard = 0, placedOrders = 0;
  Map<String, int> cart = {
    'smart': 3,
    'case': 1,
    'kettle': 1,
    'speaker': 2,
    'watch': 3,
  };
  Set<String> wishlist = {'smart', 'case', 'speaker', 'kettle'};
  List<SavedAddress> addresses = [
    const SavedAddress(
      'Home Address 1',
      '21, Alex Davidson Avenue, Opposite Omegatron, Vicent Smith Quarters',
      'Victoria Island',
      'Lagos',
      'Nigeria',
    ),
    const SavedAddress(
      'Work Address',
      '19, Martins Crescent, Bank of Nigeria',
      'Abuja',
      'Abuja',
      'Nigeria',
    ),
  ];
  List<SavedCard> cards = [
    const SavedCard('David Spade', '4543', '09/28'),
    const SavedCard('David Spade', '4560', '12/29'),
  ];
  int get itemCount => cart.values.fold(0, (a, b) => a + b);
  double get subtotal =>
      cart.entries.fold(0, (a, e) => a + productById(e.key).price * e.value);
  double get tax => subtotal == 0 ? 0 : 50;
  double get discount => voucherApplied ? subtotal * .1 : 0;
  double get total => subtotal + tax - discount;
  void _changed() {
    notifyListeners();
    _preferences?.setString(
      'store.v1',
      jsonEncode({
        'dark': dark,
        'name': name,
        'email': email,
        'cart': cart,
        'wishlist': wishlist.toList(),
        'addresses': addresses.map((a) => a.toJson()).toList(),
        'cards': cards.map((c) => c.toJson()).toList(),
        'orders': placedOrders,
      }),
    );
  }

  void toggleTheme() {
    dark = !dark;
    _changed();
  }

  void toggleWishlist(String id) {
    if (!wishlist.remove(id)) {
      wishlist.add(id);
    }
    _changed();
  }

  void addToCart(String id) {
    cart[id] = (cart[id] ?? 0) + 1;
    _changed();
  }

  void changeQuantity(String id, int delta) {
    final value = (cart[id] ?? 0) + delta;
    if (value <= 0) {
      cart.remove(id);
    } else {
      cart[id] = value;
    }
    _changed();
  }

  void removeFromCart(String id) {
    cart.remove(id);
    _changed();
  }

  bool applyVoucher(String code) {
    voucherApplied = code.trim().toUpperCase() == 'WELCOME10';
    _changed();
    return voucherApplied;
  }

  void updateProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
    _changed();
  }

  void addAddress(SavedAddress address) {
    addresses.add(address);
    selectedAddress = addresses.length - 1;
    _changed();
  }

  void chooseAddress(int index) {
    selectedAddress = index;
    _changed();
  }

  void addCard(SavedCard card) {
    cards.add(card);
    selectedCard = cards.length - 1;
    _changed();
  }

  void chooseCard(int index) {
    selectedCard = index;
    _changed();
  }

  void placeOrder() {
    placedOrders++;
    cart.clear();
    voucherApplied = false;
    _changed();
  }
}
