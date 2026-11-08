class Product {
  const Product(
    this.id,
    this.name,
    this.brand,
    this.price,
    this.image,
    this.category, {
    this.inStock = true,
  });
  final String id, name, brand, image, category;
  final double price;
  final bool inStock;
}

const products = [
  Product(
    'speaker',
    'BeoPlay Speaker',
    'Bang and Olufsen',
    755,
    'speaker',
    'Gadgets',
  ),
  Product('watch', 'Leather Wristwatch', 'Tag Heuer', 450, 'watch', 'Men'),
  Product('shirt', 'Nike Dri-FIT Long Sleeve', 'Nike', 150, 'shirt', 'Men'),
  Product('luggage', 'Smart Luggage', 'Smart Inc', 755, 'luggage', 'Gadgets'),
  Product(
    'google',
    'Bluetooth Speaker',
    'Google LLC',
    450,
    'google-speaker',
    'Devices',
  ),
  Product(
    'stand',
    'Stand Speaker',
    'Bang and Olufsen',
    755,
    'stand-speaker',
    'Gadgets',
  ),
  Product(
    'case',
    'B&o Phone Case',
    'Bang and Olufsen',
    120,
    'phone-case',
    'Gadgets',
  ),
  Product('beats', 'Beats by Dre', 'Beats', 450, 'headphones-scene', 'Gadgets'),
  Product(
    'smart',
    'Smart Home Speaker',
    'Google LLC',
    95,
    'google-speaker',
    'Devices',
  ),
  Product(
    'kettle',
    'Electric Kettle',
    'Bang and Olufsen',
    95,
    'kettle',
    'Devices',
    inStock: false,
  ),
  Product('lamp', 'B&o Desk Lamp', 'Bang and Olufsen', 450, 'lamp', 'Gadgets'),
];

Product productById(String id) => products.firstWhere((p) => p.id == id);
String money(num value, {bool decimals = false}) =>
    '\$${value.toStringAsFixed(decimals ? 2 : 0)}';

class SavedAddress {
  const SavedAddress(
    this.label,
    this.street,
    this.city,
    this.state,
    this.country,
  );
  final String label, street, city, state, country;
  String get full => '$street, $city, $state, $country';
  Map<String, String> toJson() => {
    'label': label,
    'street': street,
    'city': city,
    'state': state,
    'country': country,
  };
  factory SavedAddress.fromJson(Map<String, dynamic> j) => SavedAddress(
    j['label'],
    j['street'],
    j['city'],
    j['state'],
    j['country'],
  );
}

class SavedCard {
  const SavedCard(this.holder, this.lastFour, this.expiry);
  final String holder, lastFour, expiry;
  Map<String, String> toJson() => {
    'holder': holder,
    'lastFour': lastFour,
    'expiry': expiry,
  };
  factory SavedCard.fromJson(Map<String, dynamic> j) =>
      SavedCard(j['holder'], j['lastFour'], j['expiry']);
}
