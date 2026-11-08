import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/catalog.dart';
import '../state/store_controller.dart';
import 'checkout_screens.dart';
import 'widgets.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({
    super.key,
    required this.controller,
    required this.go,
    required this.back,
    required this.screen,
  });
  final StoreController controller;
  final Navigate go;
  final VoidCallback back;
  final AppScreen screen;

  @override
  Widget build(BuildContext context) => switch (screen) {
    AppScreen.profile => _profile(context),
    AppScreen.orders => _orders(context),
    AppScreen.tracking || AppScreen.trackingMap => _tracking(context),
    AppScreen.cards => _cards(context),
    AppScreen.addCard => CardFormScreen(controller: controller, back: back),
    AppScreen.addresses => _addresses(context),
    AppScreen.wishlist => _wishlist(context),
    AppScreen.editProfile => ProfileFormScreen(
      controller: controller,
      back: back,
    ),
    _ => const SizedBox.shrink(),
  };

  Widget _profile(BuildContext context) => ListView(
    padding: EdgeInsets.zero,
    children: [
      Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: context.soft,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.panel,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 44,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      Center(
        child: Text(
          controller.name,
          style: const TextStyle(
            fontSize: 27,
            color: AppColors.accent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: Text(controller.email, style: const TextStyle(fontSize: 14)),
      ),
      const SizedBox(height: 26),
      ...[
        ('Edit Profile', Icons.edit_outlined, AppScreen.editProfile),
        ('Shipping Address', Icons.location_on_outlined, AppScreen.addresses),
        ('Wishlist', Icons.favorite_border, AppScreen.wishlist),
        ('Order History', Icons.history, AppScreen.orders),
        ('Track Order', Icons.inventory_2_outlined, AppScreen.tracking),
        ('Cards', Icons.account_balance_wallet_outlined, AppScreen.cards),
      ].map(
        (item) => _profileRow(
          context,
          item.$1,
          item.$2,
          () => go(item.$3),
          badge: item.$3 == AppScreen.wishlist ? 'New' : null,
        ),
      ),
      _profileRow(
        context,
        'Notifications',
        Icons.notifications_none,
        () => showNotice(
          context,
          'You are all caught up. Your demo order updates appear in Order History.',
        ),
      ),
      _profileRow(
        context,
        controller.dark ? 'Light Appearance' : 'Dark Appearance',
        controller.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        controller.toggleTheme,
      ),
      _profileRow(
        context,
        'Log Out',
        Icons.logout,
        () => go(AppScreen.welcome),
      ),
      const SizedBox(height: 18),
    ],
  );
  Widget _profileRow(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback tap, {
    String? badge,
  }) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
    child: Material(
      color: context.isDark ? context.panel : AppColors.cream,
      child: InkWell(
        onTap: tap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.soft,
                child: Icon(icon, size: 20, color: context.ink),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14)),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B705B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _orders(BuildContext context) => Column(
    children: [
      _header(context, 'My Orders'),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (int i = 0; i < 4 + controller.placedOrders; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: context.panel,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => go(AppScreen.tracking),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  i == 0 ? 'In Transit' : 'Delivered',
                                  style: TextStyle(
                                    color: i == 0
                                        ? AppColors.accent
                                        : const Color(0xFF6B705B),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                i == 0 ? 'Today' : 'Sept 23, 2026',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              for (final p in [
                                products[1],
                                products[0],
                                products[9],
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    width: 58,
                                    height: 58,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: ProductImage(p),
                                    ),
                                  ),
                                ),
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: context.soft,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text('+4'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'OD - ${424923192 + i} - N',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                i == 0 ? '\$4500' : '\$700',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _tracking(BuildContext context) {
    final map = screen == AppScreen.trackingMap;
    return Column(
      children: [
        PageHeader(
          'OD - 424923192 - N',
          back: back,
          action: IconButton(
            tooltip: map ? 'Order timeline' : 'Track on map',
            onPressed: () =>
                go(map ? AppScreen.tracking : AppScreen.trackingMap),
            icon: Icon(
              map ? Icons.format_list_bulleted : Icons.map_outlined,
              color: AppColors.accent,
            ),
          ),
        ),
        Expanded(
          child: map
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/map.png', fit: BoxFit.cover),
                    CustomPaint(painter: DeliveryPathPainter()),
                    const Align(
                      alignment: Alignment(.1, .15),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        size: 35,
                        color: AppColors.accent,
                      ),
                    ),
                    const Align(
                      alignment: Alignment(.5, -.65),
                      child: Icon(
                        Icons.location_on,
                        size: 42,
                        color: AppColors.accent,
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 24,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: context.panel,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 45,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Federal Express',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text('Shipped · Lagos State, Nigeria'),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Reference map · demo location',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: context.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
                  children: [
                    for (int i = 0; i < 5; i++)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 55,
                              child: Column(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: i >= 2
                                          ? AppColors.accent
                                          : context.soft,
                                    ),
                                    child: i >= 2
                                        ? const Icon(
                                            Icons.check,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                  if (i < 4)
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: i >= 2
                                            ? AppColors.accent
                                            : context.soft,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  bottom: 42,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        'Delivered',
                                        'Out for delivery',
                                        'Shipped',
                                        'Order Processed',
                                        'Order Placed',
                                      ][i],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: i >= 2
                                            ? context.ink
                                            : context.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      i < 2
                                          ? 'Edo State, Nigeria'
                                          : 'Lagos State, Nigeria',
                                      style: TextStyle(
                                        color: context.muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (i >= 2)
                                      const Text(
                                        '10:00 AM · Nov 08',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    FilledButton(
                      onPressed: () => go(AppScreen.trackingMap),
                      child: const Text('View Delivery Map'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _cards(BuildContext context) => Column(
    children: [
      _header(context, 'Saved Cards'),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (int i = 0; i < controller.cards.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    controller.chooseCard(i);
                    showNotice(
                      context,
                      'Card ending ${controller.cards[i].lastFour} selected',
                    );
                  },
                  child: PaymentCard(card: controller.cards[i], index: i),
                ),
              ),
            const SizedBox(height: 70),
            Center(
              child: FilledButton(
                onPressed: () => go(AppScreen.addCard),
                child: const Text('Add new Card'),
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _addresses(BuildContext context) => Column(
    children: [
      _header(context, 'Shipping Address'),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            for (int i = 0; i < controller.addresses.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: InkWell(
                  onTap: () => controller.chooseAddress(i),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.panel,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: controller.selectedAddress == i
                            ? AppColors.accent
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.addresses[i].label,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              controller.selectedAddress == i
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              size: 21,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.addresses[i].full,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            color: context.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddressForm(controller: controller),
              ),
              child: const Text('Add new Address'),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _wishlist(BuildContext context) => Column(
    children: [
      _header(context, 'Wishlist'),
      Expanded(
        child: controller.wishlist.isEmpty
            ? const Center(
                child: Text('Save products you love to find them here.'),
              )
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final id in controller.wishlist)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 124,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: context.panel,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 124,
                              child: InkWell(
                                onTap: () => go(
                                  AppScreen.product,
                                  product: productById(id),
                                ),
                                child: ProductImage(productById(id)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productById(id).name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      money(productById(id).price),
                                      style: const TextStyle(
                                        color: AppColors.accent,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      productById(id).inStock
                                          ? 'In Stock'
                                          : 'Out of Stock',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: productById(id).inStock
                                            ? const Color(0xFF6B705B)
                                            : context.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  tooltip: 'Remove from wishlist',
                                  onPressed: () =>
                                      controller.toggleWishlist(id),
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: AppColors.accent,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Add to cart',
                                  onPressed: productById(id).inStock
                                      ? () {
                                          controller.addToCart(id);
                                          showNotice(context, 'Added to cart');
                                        }
                                      : null,
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    ],
  );
  Widget _header(BuildContext context, String title) => Container(
    decoration: BoxDecoration(
      color: context.soft,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
    ),
    child: PageHeader(title, back: back),
  );
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key, required this.card, this.index = 0});
  final SavedCard card;
  final int index;
  @override
  Widget build(BuildContext context) => Container(
    height: 172,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      gradient: LinearGradient(
        colors: index.isEven
            ? [const Color(0xFF4B503F), const Color(0xFF6B705B)]
            : [const Color(0xFF8D5E49), AppColors.accent],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          right: 40,
          top: -95,
          child: Container(
            width: 260,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerRight,
                child: MasterCardMark(),
              ),
              const SizedBox(height: 14),
              Text(
                '4560    5674    3224    ${card.lastFour}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFFE7E0D6),
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Holder',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: .55),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          card.holder,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: .55),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        card.expiry,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class CardFormScreen extends StatefulWidget {
  const CardFormScreen({
    super.key,
    required this.controller,
    required this.back,
  });
  final StoreController controller;
  final VoidCallback back;
  @override
  State<CardFormScreen> createState() => _CardFormScreenState();
}

class _CardFormScreenState extends State<CardFormScreen> {
  final form = GlobalKey<FormState>();
  final holder = TextEditingController(text: 'Johnathan Smith'),
      number = TextEditingController(text: '5623 4587 9658 4521'),
      expiry = TextEditingController(text: '12/29'),
      cvv = TextEditingController(text: '123');
  @override
  void dispose() {
    for (final c in [holder, number, expiry, cvv]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      PageHeader('Add New Card', back: widget.back),
      Expanded(
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              PaymentCard(
                card: SavedCard(holder.text, '4543', expiry.text),
                index: 1,
              ),
              const SizedBox(height: 30),
              StoreField('Name On Card', holder),
              StoreField(
                'Card Number',
                number,
                type: TextInputType.number,
                validator: validateCardNumber,
              ),
              Row(
                children: [
                  Expanded(
                    child: StoreField(
                      'Exp Date',
                      expiry,
                      validator: validateExpiry,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StoreField(
                      'CVV',
                      cvv,
                      obscure: true,
                      type: TextInputType.number,
                      validator: (v) => RegExp(r'^\d{3,4}$').hasMatch(v ?? '')
                          ? null
                          : 'Enter 3–4 digits',
                    ),
                  ),
                ],
              ),
              Text(
                'Demo only. Only the card label, expiry and last four digits are saved on this device.',
                style: TextStyle(
                  fontSize: 12,
                  color: context.muted,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
      BottomAction(
        label: 'Apply',
        onPressed: () {
          if (form.currentState!.validate()) {
            final digits = number.text.replaceAll(' ', '');
            widget.controller.addCard(
              SavedCard(
                holder.text.trim(),
                digits.substring(digits.length - 4),
                expiry.text,
              ),
            );
            widget.back();
          }
        },
        leading: TextButton(
          onPressed: () {
            holder.clear();
            number.clear();
            expiry.clear();
            cvv.clear();
          },
          child: const Text('Clear'),
        ),
      ),
    ],
  );
}

class AddressForm extends StatefulWidget {
  const AddressForm({super.key, required this.controller});
  final StoreController controller;
  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final form = GlobalKey<FormState>();
  final label = TextEditingController(text: 'Home Address'),
      street = TextEditingController(),
      city = TextEditingController(),
      state = TextEditingController(),
      country = TextEditingController();
  @override
  void dispose() {
    for (final c in [label, street, city, state, country]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Address',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              StoreField('Label', label),
              StoreField('Street', street),
              StoreField('City', city),
              StoreField('State', state),
              StoreField('Country', country),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      widget.controller.addAddress(
                        SavedAddress(
                          label.text.trim(),
                          street.text.trim(),
                          city.text.trim(),
                          state.text.trim(),
                          country.text.trim(),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({
    super.key,
    required this.controller,
    required this.back,
  });
  final StoreController controller;
  final VoidCallback back;
  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final form = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.controller.name),
      email = TextEditingController(text: widget.controller.email);
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      PageHeader('Edit Profile', back: widget.back),
      Expanded(
        child: Form(
          key: form,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
              ),
              const SizedBox(height: 35),
              StoreField('Name', name),
              StoreField(
                'Email',
                email,
                type: TextInputType.emailAddress,
                validator: (v) =>
                    v != null &&
                        RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                    ? null
                    : 'Enter a valid email',
              ),
            ],
          ),
        ),
      ),
      BottomAction(
        label: 'Save Profile',
        onPressed: () {
          if (form.currentState!.validate()) {
            widget.controller.updateProfile(
              name.text.trim(),
              email.text.trim(),
            );
            widget.back();
          }
        },
      ),
    ],
  );
}

class DeliveryPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .55, size.height * .77)
      ..lineTo(size.width * .55, size.height * .6)
      ..lineTo(size.width * .28, size.height * .6)
      ..lineTo(size.width * .28, size.height * .39)
      ..lineTo(size.width * .75, size.height * .39)
      ..lineTo(size.width * .75, size.height * .18);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.accent
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(
      Offset(size.width * .55, size.height * .77),
      8,
      Paint()..color = AppColors.accent,
    );
  }

  @override
  bool shouldRepaint(covariant DeliveryPathPainter oldDelegate) => false;
}
