import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../data/catalog.dart';
import '../state/store_controller.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.go,
    this.scrolled = false,
  });
  final StoreController controller;
  final Navigate go;
  final bool scrolled;
  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey('home'),
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
    children: [
      if (!scrolled) ...[
        SearchBarRow(go: go),
        const SectionTitle('Categories'),
        SizedBox(
          height: 95,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, i) {
              const names = ['Men', 'Women', 'Devices', 'Gadgets', 'Gaming'];
              const icons = [
                Icons.sports_soccer_outlined,
                Icons.checkroom_outlined,
                Icons.lightbulb_outline,
                Icons.headphones_outlined,
                Icons.sports_esports_outlined,
              ];
              return InkWell(
                onTap: () => go(AppScreen.categories),
                borderRadius: BorderRadius.circular(32),
                child: SizedBox(
                  width: 60,
                  child: !context.isDark
                      ? Image.asset(
                          'assets/images/category-${names[i].toLowerCase()}.png',
                          height: 84,
                          fit: BoxFit.contain,
                        )
                      : Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: context.soft,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icons[i],
                                size: 29,
                                color: context.ink,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Text(
                              names[i],
                              maxLines: 1,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),
      ],
      SectionTitle('Best Selling', action: () => go(AppScreen.categories)),
      productPair(context, products.take(2).toList(), go),
      SectionTitle('Featured Products', action: () => go(AppScreen.brand)),
      Row(
        children: [
          Expanded(
            child: brandCard(
              context,
              'B&o',
              '5693 Products',
              () => go(AppScreen.brand),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: brandCard(
              context,
              'Beats',
              '1124 Products',
              () => go(AppScreen.imageResults),
            ),
          ),
        ],
      ),
      SectionTitle('Featured Products', action: () => go(AppScreen.categories)),
      productPair(context, [products[3], products[4]], go),
      const SizedBox(height: 16),
      productPair(context, [products[5], products[6]], go),
      const SectionTitle('Picked for You'),
      SizedBox(
        height: 320,
        child: ProductTile(
          product: products[2],
          onTap: () => go(AppScreen.product, product: products[2]),
        ),
      ),
    ],
  );
}

Widget productPair(BuildContext context, List<Product> items, Navigate go) =>
    SizedBox(
      height: 337,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 15),
            Expanded(
              child: ProductTile(
                product: items[i],
                onTap: () => go(AppScreen.product, product: items[i]),
              ),
            ),
          ],
        ],
      ),
    );

Widget brandCard(
  BuildContext context,
  String name,
  String count,
  VoidCallback tap,
) => Material(
  color: context.panel,
  borderRadius: BorderRadius.circular(5),
  child: InkWell(
    onTap: tap,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: name == 'Beats' ? const Color(0xFFFA2034) : AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name == 'Apple Inc'
                    ? '●'
                    : name == 'Beats'
                    ? 'b'
                    : name == 'Google'
                    ? 'G'
                    : 'B&O',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: name == 'B&o' ? 12 : 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 5),
                Text(
                  count,
                  style: TextStyle(fontSize: 11, color: context.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

class SearchBarRow extends StatelessWidget {
  const SearchBarRow({super.key, required this.go});
  final Navigate go;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Material(
          color: context.panel,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => go(AppScreen.search),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 18, color: AppColors.accent),
                  const SizedBox(width: 13),
                  Flexible(
                    child: Text(
                      'Search for anything...',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: context.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 16),
      IconButton.filledTonal(
        tooltip: 'Image search',
        onPressed: () => go(AppScreen.imageSearch),
        style: IconButton.styleFrom(
          backgroundColor: context.soft,
          foregroundColor: AppColors.accent,
          fixedSize: const Size(50, 50),
        ),
        icon: const Icon(Icons.camera_alt_rounded, size: 21),
      ),
    ],
  );
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
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
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String tab = 'All';
  bool filtered = false;
  late bool filterOpen = {
    AppScreen.filter,
    AppScreen.filterExpanded,
  }.contains(widget.screen);
  late bool expanded = widget.screen == AppScreen.filterExpanded;
  RangeValues price = const RangeValues(30, 1200);
  int color = 0, rating = 4;
  String brands = 'Apple, Samsung, Huawei, B&o';
  @override
  Widget build(BuildContext context) {
    final brand = widget.screen != AppScreen.categories;
    var items = brand
        ? [products[5], products[6], products[0], products[7]]
        : [products[0], products[10], products[2], products[1]];
    if (tab != 'All') {
      items = items
          .where(
            (p) => tab == 'Speakers'
                ? p.name.contains('Speaker')
                : tab == 'Headphones'
                ? p.id == 'beats'
                : false,
          )
          .toList();
    }
    if (filtered) {
      items = items
          .where((p) => p.price >= price.start && p.price <= price.end)
          .toList();
    }
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.soft,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
              ),
              child: PageHeader(
                brand ? 'B&o' : 'Gadgets',
                back: widget.back,
                action: IconButton(
                  tooltip: 'Search',
                  onPressed: () => widget.go(AppScreen.search),
                  icon: const Icon(Icons.search, color: AppColors.accent),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (!brand) ...[
                    SectionTitle(
                      'Top Products',
                      action: () => widget.go(AppScreen.brand),
                    ),
                    for (final pair in [
                      ['B&o', 'Apple Inc'],
                      ['Beats', 'Google'],
                    ])
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: brandCard(
                                context,
                                pair[0],
                                pair[0] == 'B&o'
                                    ? '563 Products'
                                    : '124 Products',
                                () => widget.go(AppScreen.brand),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: brandCard(
                                context,
                                pair[1],
                                '93 Products',
                                () => widget.go(AppScreen.brand),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ] else
                    SizedBox(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            ['All', 'Headphones', 'Speakers', 'Microphones']
                                .map(
                                  (name) => Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ChoiceChip(
                                      label: Text(name),
                                      selected: tab == name,
                                      onSelected: (_) =>
                                          setState(() => tab = name),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  SectionTitle(
                    'New Launches',
                    action: () => setState(() {
                      tab = 'All';
                      filtered = false;
                    }),
                  ),
                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 80),
                      child: Center(
                        child: Text('No products match these filters.'),
                      ),
                    ),
                  for (int i = 0; i < items.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: productPair(
                        context,
                        items.skip(i).take(2).toList(),
                        widget.go,
                      ),
                    ),
                ],
              ),
            ),
            BottomAction(
              label: 'Filter',
              onPressed: () => setState(() => filterOpen = true),
              leading: Text(
                filtered
                    ? '${items.length} products · Filters applied'
                    : 'No filters applied',
                style: const TextStyle(fontSize: 13, color: AppColors.accent),
              ),
            ),
          ],
        ),
        if (filterOpen) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => filterOpen = false),
              child: ColoredBox(color: Colors.black.withValues(alpha: .35)),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: expanded ? .90 : .78,
              widthFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: BoxDecoration(
                        color: context.muted.withValues(alpha: .3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    PageHeader(
                      'Filter',
                      action: TextButton(
                        onPressed: () => setState(() {
                          price = const RangeValues(30, 1200);
                          color = 0;
                          rating = 4;
                          brands = 'Apple, Samsung, Huawei, B&o';
                          filtered = false;
                        }),
                        child: const Text('Clear'),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          _filterRow(
                            'Popularity',
                            'No Setting',
                            () => showNotice(context, 'Sorted by popularity'),
                          ),
                          _filterRow(
                            'Brands',
                            brands,
                            () => setState(
                              () => brands = brands == 'B&o'
                                  ? 'Apple, Samsung, Huawei, B&o'
                                  : 'B&o',
                            ),
                          ),
                          _filterRow(
                            'Price',
                            '${money(price.start)} - ${money(price.end)}',
                            () => setState(() => expanded = !expanded),
                          ),
                          if (expanded)
                            RangeSlider(
                              values: price,
                              min: 0,
                              max: 1500,
                              divisions: 30,
                              labels: RangeLabels(
                                money(price.start),
                                money(price.end),
                              ),
                              onChanged: (v) => setState(() => price = v),
                            ),
                          _filterRow(
                            'Color',
                            color == 0 ? 'No Setting' : 'Selected',
                            () => setState(() => expanded = true),
                          ),
                          if (expanded)
                            Wrap(
                              spacing: 16,
                              children: List.generate(
                                6,
                                (i) => GestureDetector(
                                  onTap: () => setState(() => color = i + 1),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: [
                                        Colors.black,
                                        Colors.white,
                                        AppColors.accent,
                                        Colors.blueGrey,
                                        Colors.red,
                                        Colors.green,
                                      ][i],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: color == i + 1
                                            ? AppColors.accent
                                            : Colors.grey,
                                        width: color == i + 1 ? 3 : 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          _filterRow(
                            'Rating',
                            '$rating Star',
                            () => setState(
                              () => rating = rating == 5 ? 1 : rating + 1,
                            ),
                          ),
                          _filterRow(
                            'Shipped From',
                            'No Setting',
                            () => showNotice(
                              context,
                              'All shipping origins selected',
                            ),
                          ),
                        ],
                      ),
                    ),
                    BottomAction(
                      label: 'Apply',
                      onPressed: () => setState(() {
                        filtered = true;
                        filterOpen = false;
                      }),
                      leading: TextButton(
                        onPressed: () => setState(() => filterOpen = false),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _filterRow(String title, String subtitle, VoidCallback tap) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: context.panel,
      borderRadius: BorderRadius.circular(5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: context.muted),
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: tap,
      ),
    ),
  );
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.controller,
    required this.go,
    this.suggestions = false,
  });
  final StoreController controller;
  final Navigate go;
  final bool suggestions;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final query = TextEditingController(
    text: widget.suggestions ? 'iPhon' : '',
  );
  String value = '';
  @override
  void initState() {
    super.initState();
    value = query.text;
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = products
        .where(
          (p) => '${p.name} ${p.brand}'.toLowerCase().contains(
            value.toLowerCase(),
          ),
        )
        .toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const Key('search_input'),
                controller: query,
                onChanged: (v) => setState(() => value = v),
                decoration: InputDecoration(
                  hintText: 'Search for anything...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.accent),
                  suffixIcon: value.isNotEmpty
                      ? IconButton(
                          tooltip: 'Clear search',
                          onPressed: () => setState(() {
                            query.clear();
                            value = '';
                          }),
                          icon: const Icon(Icons.close, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: context.panel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'Image search',
              onPressed: () => widget.go(AppScreen.imageSearch),
              icon: const Icon(Icons.camera_alt, color: AppColors.accent),
            ),
          ],
        ),
        if (value.isEmpty) ...[
          const SectionTitle('Recent Searches'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      'Sport wears',
                      'Shoes',
                      'Apple',
                      'Macbook',
                      'Bang and Olufsen',
                      'Caps',
                    ]
                    .map(
                      (s) => ActionChip(
                        label: Text(s),
                        onPressed: () => setState(() {
                          query.text = s;
                          value = s;
                        }),
                        backgroundColor: context.soft,
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
          ),
          SectionTitle(
            'Recent Searches',
            action: () => widget.go(AppScreen.categories),
          ),
          productPair(context, products.take(2).toList(), widget.go),
        ] else ...[
          const SizedBox(height: 18),
          if (value.toLowerCase().startsWith('iph'))
            ...[
              'iPhone X 64GB',
              'iPhone Xs Max 128GB',
              'iPhone Xr Black 256GB',
              'iPhone X 256GB',
              'iPhone XS',
              'iPhone Xs Max',
            ].map(
              (s) => ListTile(
                title: Text(s),
                trailing: const Icon(Icons.north_west, size: 18),
                onTap: () => showNotice(
                  context,
                  'This reference suggestion has no demo inventory. Search for Speaker, Nike or Watch.',
                ),
              ),
            ),
          SectionTitle('${results.length} products found'),
          for (int i = 0; i < results.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: productPair(
                context,
                results.skip(i).take(2).toList(),
                widget.go,
              ),
            ),
          if (results.isEmpty)
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 44, color: context.muted),
                  const SizedBox(height: 16),
                  const Text('Try Speaker, Nike or Watch.'),
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class ImageSearchScreen extends StatelessWidget {
  const ImageSearchScreen({
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
  Widget build(BuildContext context) {
    final scanning = screen == AppScreen.imageSearch;
    return Column(
      children: [
        PageHeader(
          scanning
              ? 'Image Search'
              : screen == AppScreen.imageResults
              ? '15 Items found'
              : 'Beats by Dre',
          back: back,
        ),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/headphones-scene.png',
                fit: BoxFit.cover,
              ),
              if (scanning) ...[
                Container(color: Colors.black.withValues(alpha: .15)),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 100),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .9),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Chip(label: Text('SCANNING · DEMO')),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 30,
                  child: FilledButton(
                    onPressed: () => go(AppScreen.imageResults),
                    child: const Text('Find Similar Items'),
                  ),
                ),
              ] else
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 300,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProductTile(
                            product: products[7],
                            onTap: () => go(AppScreen.imageResultDetail),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ProductTile(
                            product: products[7],
                            onTap: () =>
                                go(AppScreen.product, product: products[7]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (scanning)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Reference image demo · no camera capture',
              style: TextStyle(fontSize: 12, color: context.muted),
            ),
          ),
        if (screen == AppScreen.imageResultDetail)
          BottomAction(
            label: 'View Product',
            onPressed: () => go(AppScreen.product, product: products[7]),
          ),
      ],
    );
  }
}

class ProductScreen extends StatefulWidget {
  const ProductScreen({
    super.key,
    required this.controller,
    required this.product,
    required this.go,
    required this.back,
    this.reviews = false,
  });
  final StoreController controller;
  final Product product;
  final Navigate go;
  final VoidCallback back;
  final bool reviews;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String size = 'XL';
  int colour = 0;
  bool readMore = false;
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              if (!widget.reviews)
                Stack(
                  children: [
                    SizedBox(
                      height: 390,
                      width: double.infinity,
                      child: ProductImage(p),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: IconButton.filledTonal(
                        tooltip: 'Back',
                        onPressed: widget.back,
                        icon: const Icon(Icons.chevron_left),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: IconButton.filledTonal(
                        tooltip: 'Save product',
                        onPressed: () => widget.controller.toggleWishlist(p.id),
                        icon: Icon(
                          widget.controller.wishlist.contains(p.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                )
              else
                PageHeader(p.name, back: widget.back),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.reviews)
                      Text(
                        p.name,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Size',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: size,
                                  underline: const SizedBox(),
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontFamily: 'Quicksand',
                                  ),
                                  items: ['S', 'M', 'L', 'XL', 'XXL']
                                      .map(
                                        (s) => DropdownMenuItem(
                                          value: s,
                                          child: Text(s),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => size = v!),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 49,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Colour',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const Spacer(),
                                ...List.generate(
                                  4,
                                  (i) => GestureDetector(
                                    onTap: () => setState(() => colour = i),
                                    child: Container(
                                      width: 14,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: [
                                          AppColors.accent,
                                          const Color(0xFFE4C6AF),
                                          const Color(0xFFAAA992),
                                          const Color(0xFF676C59),
                                        ][i],
                                        borderRadius: BorderRadius.circular(4),
                                        border: colour == i
                                            ? Border.all(
                                                color: context.ink,
                                                width: 1.5,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.id == 'shirt'
                          ? 'Nike Dri-FIT is a polyester fabric designed to help you keep dry so you can more comfortably work harder, longer.'
                          : '${p.name} by ${p.brand}. Thoughtful design, crafted materials and everyday performance.',
                      style: const TextStyle(fontSize: 14, height: 1.8),
                    ),
                    TextButton(
                      onPressed: () => setState(() => readMore = !readMore),
                      child: Text(readMore ? 'Read Less' : 'Read More...'),
                    ),
                    if (readMore)
                      const Text(
                        'Designed for everyday use. Free standard delivery on eligible orders. Returns accepted within 30 days.',
                        style: TextStyle(height: 1.7),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _review(context),
                          child: const Text('Write your review'),
                        ),
                      ],
                    ),
                    for (final review in [
                      (
                        'Beth Aida',
                        'I love this, paired it with a nice blouse and all eyes on me.',
                      ),
                      (
                        'Samuel Smith',
                        'Wonderful quality, a perfect gift for our anniversary!',
                      ),
                    ])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: context.soft,
                                  child: Text(
                                    review.$1[0],
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    review.$1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Text(
                                  '★★★★★',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review.$2,
                              style: TextStyle(
                                color: context.muted,
                                height: 1.7,
                              ),
                            ),
                            const Divider(height: 24),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        BottomAction(
          label: p.inStock ? 'Add to Cart' : 'Out of Stock',
          onPressed: p.inStock
              ? () {
                  widget.controller.addToCart(p.id);
                  showNotice(context, '${p.name} added to cart');
                }
              : null,
          leading: Row(
            children: [
              Text(
                money(p.price, decimals: true),
                style: const TextStyle(fontSize: 17),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Open cart',
                onPressed: () => widget.go(AppScreen.cart),
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _review(BuildContext context) async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) => const _ReviewDialog(),
    );
    if (text != null && context.mounted) {
      showNotice(context, 'Thank you! Your demo review was submitted.');
    }
  }
}

class _ReviewDialog extends StatefulWidget {
  const _ReviewDialog();
  @override
  State<_ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<_ReviewDialog> {
  final text = TextEditingController();
  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Write your review'),
    content: TextField(
      controller: text,
      maxLines: 3,
      decoration: const InputDecoration(hintText: 'How was your product?'),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          if (text.text.trim().isNotEmpty) Navigator.pop(context, text.text);
        },
        child: const Text('Submit'),
      ),
    ],
  );
}
