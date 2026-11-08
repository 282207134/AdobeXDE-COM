import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/catalog.dart';
import '../state/store_controller.dart';
import 'widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.controller, required this.go});
  final StoreController controller;
  final Navigate go;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final voucher = TextEditingController();
  @override
  void dispose() {
    voucher.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Column(
      children: [
        PageHeader(
          'Cart',
          action: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${c.itemCount} items',
              style: TextStyle(fontSize: 13, color: context.muted),
            ),
          ),
        ),
        Expanded(
          child: c.cart.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 65,
                        color: AppColors.accent.withValues(alpha: .5),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 21),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => widget.go(AppScreen.home),
                        child: const Text('Explore Products'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final entry in c.cart.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: ValueKey('cart_${entry.key}'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) => c.removeFromCart(entry.key),
                          child: Container(
                            height: 124,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: context.panel,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 124,
                                  child: InkWell(
                                    onTap: () => widget.go(
                                      AppScreen.product,
                                      product: productById(entry.key),
                                    ),
                                    child: ProductImage(productById(entry.key)),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      14,
                                      10,
                                      8,
                                      8,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productById(entry.key).name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          money(productById(entry.key).price),
                                          style: const TextStyle(
                                            color: AppColors.accent,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                              tooltip: 'Save for later',
                                              onPressed: () =>
                                                  c.toggleWishlist(entry.key),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              icon: Icon(
                                                c.wishlist.contains(entry.key)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 18,
                                                color: AppColors.accent,
                                              ),
                                            ),
                                            const Spacer(),
                                            _counter(
                                              c,
                                              entry.key,
                                              Icons.remove,
                                              -1,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Text('${entry.value}'),
                                            ),
                                            _counter(
                                              c,
                                              entry.key,
                                              Icons.add,
                                              1,
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
                        ),
                      ),
                    const Divider(height: 32),
                    _totalRow('Sub Total', money(c.subtotal)),
                    _totalRow('Tax', money(c.tax)),
                    if (c.voucherApplied)
                      _totalRow('Welcome discount', '-${money(c.discount)}'),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            key: const Key('voucher_input'),
                            controller: voucher,
                            decoration: const InputDecoration(
                              hintText: 'Enter Voucher Code',
                              contentPadding: EdgeInsets.all(14),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        FilledButton(
                          onPressed: () {
                            final ok = c.applyVoucher(voucher.text);
                            showNotice(
                              context,
                              ok
                                  ? '10% discount applied'
                                  : 'Use WELCOME10 for 10% off',
                            );
                          },
                          child: const Text('APPLY'),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Try WELCOME10',
                        style: TextStyle(fontSize: 12, color: context.muted),
                      ),
                    ),
                  ],
                ),
        ),
        if (c.cart.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total : ${money(c.total)}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FilledButton(
                  key: const Key('checkout_button'),
                  onPressed: () => widget.go(AppScreen.delivery),
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _counter(StoreController c, String id, IconData icon, int delta) =>
      SizedBox(
        width: 30,
        height: 30,
        child: IconButton(
          key: Key('${delta > 0 ? 'increment' : 'decrement'}_$id'),
          onPressed: () => c.changeQuantity(id, delta),
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(backgroundColor: context.soft),
          icon: Icon(icon, size: 16, color: AppColors.accent),
        ),
      );
  Widget _totalRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: context.muted)),
        ),
        Text(value),
      ],
    ),
  );
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
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
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final form = GlobalKey<FormState>();
  late final street = TextEditingController(
    text: widget.controller.addresses[widget.controller.selectedAddress].street,
  );
  final street2 = TextEditingController(
    text: 'Opposite Omegatron, Vicent Quarters',
  );
  late final city = TextEditingController(
    text: widget.controller.addresses[widget.controller.selectedAddress].city,
  );
  late final state = TextEditingController(
    text: widget.controller.addresses[widget.controller.selectedAddress].state,
  );
  late final country = TextEditingController(
    text:
        widget.controller.addresses[widget.controller.selectedAddress].country,
  );
  final holder = TextEditingController(text: 'Johnathan Smith');
  final number = TextEditingController(text: '5623 4587 9658 4521');
  final expiry = TextEditingController(text: '12/29');
  final cvv = TextEditingController(text: '123');
  bool save = true, billing = true;
  DateTime? deliveryDate;
  int method = 1;
  @override
  void dispose() {
    for (final c in [
      street,
      street2,
      city,
      state,
      country,
      holder,
      number,
      expiry,
      cvv,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void next() {
    final c = widget.controller;
    if (widget.screen == AppScreen.delivery) {
      widget.go(AppScreen.address);
      return;
    }
    if (!form.currentState!.validate()) return;
    if (widget.screen == AppScreen.address) {
      c.checkoutAddress = SavedAddress(
        'Delivery Address',
        street.text.trim(),
        city.text.trim(),
        state.text.trim(),
        country.text.trim(),
      );
      if (save && !c.addresses.any((a) => a.full == c.checkoutAddress!.full)) {
        c.addAddress(c.checkoutAddress!);
      }
      widget.go(AppScreen.payment);
    } else if (widget.screen == AppScreen.payment) {
      final digits = number.text.replaceAll(RegExp(r'\D'), '');
      c.checkoutCard = SavedCard(
        holder.text.trim(),
        digits.substring(digits.length - 4),
        expiry.text.trim(),
      );
      if (save &&
          !c.cards.any((card) => card.lastFour == c.checkoutCard!.lastFour)) {
        c.addCard(c.checkoutCard!);
      }
      widget.go(AppScreen.summary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    if (widget.screen == AppScreen.success) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: context.soft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Order Placed!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your demo order is on its way.\nNo payment has been charged.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.8),
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: () => widget.go(AppScreen.tracking),
                child: const Text('Track Order'),
              ),
              TextButton(
                onPressed: () => widget.go(AppScreen.home),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      );
    }
    final summary = widget.screen == AppScreen.summary;
    final step = widget.screen == AppScreen.delivery
        ? 0
        : widget.screen == AppScreen.address
        ? 1
        : 2;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.soft,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
          ),
          child: PageHeader(
            'Checkout',
            back: widget.back,
            action: const Padding(
              padding: EdgeInsets.only(right: 24),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: AppColors.accent,
                size: 22,
              ),
            ),
          ),
        ),
        Expanded(
          child: Form(
            key: form,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                if (!summary) ...[
                  _steps(context, step),
                  const SizedBox(height: 30),
                ],
                if (widget.screen == AppScreen.delivery) ..._delivery(context),
                if (widget.screen == AppScreen.address) ...[
                  StoreField('Street 1', street),
                  StoreField(
                    'Street 2 (optional)',
                    street2,
                    validator: (_) => null,
                  ),
                  StoreField('City', city),
                  StoreField('State', state),
                  StoreField('Country', country),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: billing,
                    onChanged: (v) => setState(() => billing = v!),
                    title: const Text(
                      'Billing address is the same as delivery address.',
                      style: TextStyle(fontSize: 13),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (!billing)
                    const Text(
                      'For this demo the billing address is collected by the payment provider when connected.',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: save,
                    onChanged: (v) => setState(() => save = v!),
                    title: const Text(
                      'Save this Address',
                      style: TextStyle(fontSize: 13),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
                if (widget.screen == AppScreen.payment) ...[
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 58),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              backgroundColor: method == i
                                  ? const Color(0xFF6B705B)
                                  : Colors.transparent,
                              foregroundColor: method == i
                                  ? Colors.white
                                  : const Color(0xFF6B705B),
                            ),
                            onPressed: () => setState(() => method = i),
                            child: Icon(
                              [
                                Icons.paypal,
                                Icons.account_balance_wallet_outlined,
                                Icons.credit_card,
                              ][i],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (method != 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Text(
                        'Demo payment method. No provider is connected.',
                        style: TextStyle(fontSize: 12, color: context.muted),
                      ),
                    ),
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
                          type: TextInputType.datetime,
                          validator: validateExpiry,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: StoreField(
                          'CVV',
                          cvv,
                          obscure: true,
                          type: TextInputType.number,
                          validator: (v) =>
                              RegExp(r'^\d{3,4}$').hasMatch(v ?? '')
                              ? null
                              : 'Enter 3–4 digits',
                        ),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: save,
                    onChanged: (v) => setState(() => save = v!),
                    title: const Text(
                      'Save card label and last 4 digits',
                      style: TextStyle(fontSize: 12),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Text(
                    'Demo only. Full card number and CVV are never saved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.muted,
                      height: 1.6,
                    ),
                  ),
                ],
                if (summary) ..._summary(context),
              ],
            ),
          ),
        ),
        BottomAction(
          label: summary ? 'PAY NOW' : 'Continue',
          onPressed: summary
              ? (c.cart.isEmpty
                    ? null
                    : () {
                        c.placeOrder();
                        widget.go(AppScreen.success);
                      })
              : next,
          leading: summary
              ? TextButton(onPressed: widget.back, child: const Text('Back'))
              : Text(
                  widget.screen == AppScreen.delivery
                      ? '${c.delivery} Selected'
                      : 'Step ${step + 1} of 3',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accent.withValues(alpha: .75),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _steps(BuildContext context, int current) => Container(
    padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
    decoration: BoxDecoration(
      color: context.panel,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: i == 0
                          ? Colors.transparent
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: i <= current ? AppColors.accent : context.soft,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: i == 2
                          ? Colors.transparent
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                ['Delivery', 'Address', 'Payments'][i],
                style: TextStyle(
                  fontSize: 12,
                  color: i <= current ? context.ink : context.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  List<Widget> _delivery(BuildContext context) => [
    for (final option in [
      (
        'Standard Delivery',
        'Order will be delivered between 3 - 5 business days',
      ),
      (
        'Next Day Delivery',
        'Place your order before 6pm and your items will be delivered the next day',
      ),
      (
        'Nominated Delivery',
        'Pick a particular date from the calendar and order will be delivered on selected date',
      ),
    ]) ...[
      const Divider(),
      InkWell(
        onTap: () async {
          if (option.$1 == 'Nominated Delivery') {
            final now = DateTime.now();
            final date = await showDatePicker(
              context: context,
              initialDate: now.add(const Duration(days: 3)),
              firstDate: now.add(const Duration(days: 1)),
              lastDate: now.add(const Duration(days: 90)),
            );
            if (date == null) return;
            deliveryDate = date;
          }
          setState(() => widget.controller.delivery = option.$1);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.$1,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Icon(
                    widget.controller.delivery == option.$1
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                option.$2,
                style: const TextStyle(fontSize: 14, height: 1.8),
              ),
              if (option.$1 == 'Nominated Delivery' && deliveryDate != null)
                Text(
                  '${deliveryDate!.year}-${deliveryDate!.month}-${deliveryDate!.day}',
                  style: const TextStyle(color: AppColors.accent),
                ),
            ],
          ),
        ),
      ),
    ],
    const Divider(),
  ];

  List<Widget> _summary(BuildContext context) {
    final c = widget.controller;
    final address = c.checkoutAddress ?? c.addresses[c.selectedAddress];
    final card = c.checkoutCard ?? c.cards[c.selectedCard];
    return [
      SizedBox(
        height: 205,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: c.cart.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, i) {
            final p = productById(c.cart.keys.elementAt(i));
            return SizedBox(
              width: 120,
              child: ProductTile(
                product: p,
                onTap: () => widget.go(AppScreen.product, product: p),
              ),
            );
          },
        ),
      ),
      const Divider(height: 40),
      _summaryHeader('Shipping Address', () => widget.go(AppScreen.address)),
      const SizedBox(height: 16),
      Text(address.full, style: const TextStyle(fontSize: 16, height: 1.7)),
      const Divider(height: 40),
      _summaryHeader('Payment', () => widget.go(AppScreen.payment)),
      const SizedBox(height: 22),
      Row(
        children: [
          const MasterCardMark(),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Master Card',
                style: TextStyle(fontSize: 12, color: context.muted),
              ),
              Text(
                '****  ****  ****  ${card.lastFour}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
      const Divider(height: 40),
      Row(
        children: [
          const Expanded(
            child: Text('Order Total', style: TextStyle(fontSize: 18)),
          ),
          Text(
            money(c.total),
            style: const TextStyle(
              fontSize: 21,
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Text(
        'Demo checkout · no real payment',
        style: TextStyle(fontSize: 12, color: context.muted),
      ),
    ];
  }

  Widget _summaryHeader(String title, VoidCallback tap) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      TextButton(onPressed: tap, child: const Text('Change')),
    ],
  );
}

String? validateCardNumber(String? value) {
  final digits = (value ?? '').replaceAll(RegExp(r'\s'), '');
  return RegExp(r'^\d{16}$').hasMatch(digits)
      ? null
      : 'Enter a 16-digit demo card number';
}

String? validateExpiry(String? value) {
  final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$').firstMatch(value ?? '');
  if (match == null) return 'Use MM/YY';
  final now = DateTime.now();
  final year = 2000 + int.parse(match[2]!);
  final month = int.parse(match[1]!);
  return year < now.year || (year == now.year && month < now.month)
      ? 'Card has expired'
      : null;
}

class MasterCardMark extends StatelessWidget {
  const MasterCardMark({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 45,
    height: 28,
    child: Stack(
      children: [
        Positioned(
          left: 0,
          child: CircleAvatar(radius: 14, backgroundColor: Color(0xFFFF4C00)),
        ),
        Positioned(
          right: 0,
          child: CircleAvatar(radius: 14, backgroundColor: Color(0xFFFFBC00)),
        ),
      ],
    ),
  );
}
