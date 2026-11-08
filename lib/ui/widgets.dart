import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/catalog.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(this.product, {super.key, this.fit = BoxFit.cover});
  final Product product;
  final BoxFit fit;
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/${product.image}.png',
    fit: fit,
    errorBuilder: (_, error, stack) => ColoredBox(
      color: context.soft,
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 48,
          color: AppColors.accent,
        ),
      ),
    ),
  );
}

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
    this.onFavorite,
    this.favorite = false,
  });
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final bool favorite;
  @override
  Widget build(BuildContext context) => Material(
    color: context.panel,
    borderRadius: BorderRadius.circular(16),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ProductImage(product),
                if (onFavorite != null)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                      tooltip: 'Save ${product.name}',
                      onPressed: onFavorite,
                      style: IconButton.styleFrom(
                        backgroundColor: context.panel.withValues(alpha: .9),
                      ),
                      iconSize: 18,
                      icon: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  product.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: context.muted),
                ),
                const SizedBox(height: 8),
                Text(
                  money(product.price),
                  style: const TextStyle(fontSize: 16, color: AppColors.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
    this.title, {
    super.key,
    this.action,
    this.actionLabel = 'See all',
  });
  final String title, actionLabel;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(7, 18, 0, 16),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        if (action != null)
          TextButton(onPressed: action, child: Text(actionLabel)),
      ],
    ),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader(this.title, {super.key, this.back, this.action});
  final String title;
  final VoidCallback? back;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
    child: Row(
      children: [
        if (back != null)
          IconButton(
            tooltip: 'Back',
            onPressed: back,
            icon: const Icon(Icons.chevron_left, size: 25),
          )
        else
          const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        ?action,
      ],
    ),
  );
}

class BottomAction extends StatelessWidget {
  const BottomAction({
    super.key,
    required this.label,
    this.onPressed,
    this.leading,
  });
  final String label;
  final VoidCallback? onPressed;
  final Widget? leading;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.soft,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
    ),
    padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
    child: Row(
      children: [
        if (leading != null) Expanded(child: leading!),
        if (leading != null) const SizedBox(width: 18),
        Expanded(
          child: FilledButton(onPressed: onPressed, child: Text(label)),
        ),
      ],
    ),
  );
}

class StoreField extends StatelessWidget {
  const StoreField(
    this.label,
    this.controller, {
    super.key,
    this.obscure = false,
    this.type,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? type;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      decoration: InputDecoration(labelText: label),
      validator:
          validator ??
          (value) =>
              value == null || value.trim().isEmpty ? 'Enter $label' : null,
    ),
  );
}

void showNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 110),
    ),
  );
}
