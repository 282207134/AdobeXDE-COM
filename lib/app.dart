import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_theme.dart';
import 'core/routes.dart';
import 'data/catalog.dart';
import 'state/store_controller.dart';
import 'ui/auth_screens.dart';
import 'ui/catalog_screens.dart';
import 'ui/checkout_screens.dart';
import 'ui/account_screens.dart';

class StoreApp extends StatefulWidget {
  const StoreApp({
    super.key,
    required this.controller,
    this.initialScreen = AppScreen.welcome,
  });
  final StoreController controller;
  final AppScreen initialScreen;
  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  late AppScreen screen = widget.initialScreen;
  final history = <AppScreen>[];
  Product selectedProduct = productById('shirt');
  void go(AppScreen next, {Product? product}) {
    if (next == screen && product == null) return;
    setState(() {
      history.add(screen);
      screen = next;
      if (product != null) selectedProduct = product;
    });
  }

  void back() => setState(
    () => screen = history.isEmpty ? AppScreen.home : history.removeLast(),
  );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.controller,
    builder: (_, _) {
      final dark = widget.controller.dark;
      return MaterialApp(
        title: 'E-COM',
        debugShowCheckedModeBanner: false,
        theme: storeTheme(Brightness.light),
        darkTheme: storeTheme(Brightness.dark),
        themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        builder: (context, child) => ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child!,
            ),
          ),
        ),
        home: Builder(
          builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                    .copyWith(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Theme.of(context)
                          .scaffoldBackgroundColor,
                    ),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) back();
              },
              child: Scaffold(
                body: SafeArea(
                  child: KeyedSubtree(key: ValueKey(screen), child: _page()),
                ),
                bottomNavigationBar: _hasNavigation
                    ? SafeArea(top: false, child: _navigation(context))
                    : null,
              ),
            ),
          ),
        ),
      );
    },
  );

  bool get _hasNavigation => {
    AppScreen.home,
    AppScreen.homeScroll,
    AppScreen.search,
    AppScreen.suggestions,
    AppScreen.cart,
    AppScreen.profile,
    AppScreen.orders,
    AppScreen.cards,
  }.contains(screen);

  Widget _navigation(BuildContext context) {
    final current = switch (screen) {
      AppScreen.search || AppScreen.suggestions => 1,
      AppScreen.cart => 2,
      AppScreen.profile || AppScreen.orders || AppScreen.cards => 3,
      _ => 0,
    };
    const targets = [
      AppScreen.home,
      AppScreen.search,
      AppScreen.cart,
      AppScreen.profile,
    ];
    const icons = [
      Icons.home_rounded,
      Icons.search,
      Icons.shopping_cart_rounded,
      Icons.person,
    ];
    const labels = ['Home', 'Search', 'Cart', 'Profile'];
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: context.soft,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: List.generate(
          4,
          (i) => Expanded(
            flex: current == i ? 17 : 10,
            child: Semantics(
              selected: current == i,
              button: true,
              label: labels[i],
              child: InkWell(
                key: Key('nav_${labels[i].toLowerCase()}'),
                borderRadius: BorderRadius.circular(24),
                onTap: () => go(targets[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 9),
                  decoration: BoxDecoration(
                    color: current == i ? context.panel : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icons[i], color: AppColors.accent, size: 23),
                      if (current == i) ...[
                        const SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            labels[i],
                            maxLines: 1,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _page() {
    final c = widget.controller;
    return switch (screen) {
      AppScreen.welcome || AppScreen.signup || AppScreen.verification =>
        AuthScreen(screen: screen, controller: c, go: go),
      AppScreen.home || AppScreen.homeScroll => HomeScreen(
        controller: c,
        go: go,
        scrolled: screen == AppScreen.homeScroll,
      ),
      AppScreen.categories ||
      AppScreen.brand ||
      AppScreen.filter ||
      AppScreen.filterExpanded => CatalogScreen(
        controller: c,
        go: go,
        back: back,
        screen: screen,
      ),
      AppScreen.search || AppScreen.suggestions => SearchScreen(
        controller: c,
        go: go,
        suggestions: screen == AppScreen.suggestions,
      ),
      AppScreen.imageSearch ||
      AppScreen.imageResults ||
      AppScreen.imageResultDetail => ImageSearchScreen(
        controller: c,
        go: go,
        back: back,
        screen: screen,
      ),
      AppScreen.product || AppScreen.reviews => ProductScreen(
        controller: c,
        product: selectedProduct,
        go: go,
        back: back,
        reviews: screen == AppScreen.reviews,
      ),
      AppScreen.cart => CartScreen(controller: c, go: go),
      AppScreen.delivery ||
      AppScreen.address ||
      AppScreen.payment ||
      AppScreen.summary ||
      AppScreen.success => CheckoutScreen(
        controller: c,
        go: go,
        back: back,
        screen: screen,
      ),
      _ => AccountScreen(controller: c, go: go, back: back, screen: screen),
    };
  }
}
