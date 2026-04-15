import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../models/scheme_model.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon ?? Icons.arrow_forward_rounded),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon == null ? null : Icon(icon),
      ),
    );
  }
}

class SchemeCard extends StatelessWidget {
  const SchemeCard({
    super.key,
    required this.scheme,
    required this.onTap,
    required this.isSaved,
    required this.onSave,
  });

  final SchemeModel scheme;
  final VoidCallback onTap;
  final bool isSaved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppTheme.ink.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CategoryBadge(category: scheme.category),
                const Spacer(),
                IconButton(
                  onPressed: onSave,
                  icon: Icon(isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
                  color: isSaved ? AppTheme.saffron : AppTheme.muted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              scheme.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              scheme.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.muted, height: 1.45),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.verified_user_outlined, size: 18, color: AppTheme.teal),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    scheme.applicationMode,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Text('${scheme.popularity}% match', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppTheme.ink,
          fontWeight: FontWeight.w800,
        ),
        selectedColor: AppTheme.primary,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppTheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemBuilder: (_, __) => Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemCount: 4,
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w900, fontSize: 12),
      ),
    );
  }
}
