import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common_widgets.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _age = TextEditingController();
  final _state = TextEditingController(text: 'Karnataka');
  final _district = TextEditingController();
  final _occupation = TextEditingController(text: 'Student');
  final _income = TextEditingController(text: '240000');
  final _education = TextEditingController(text: 'Undergraduate');

  String _category = 'General';
  String _gender = 'Male';
  bool _isMarried = false;
  bool _hasDisability = false;

  static const _categories = ['General', 'OBC', 'SC', 'ST', 'EWS'];
  static const _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void dispose() {
    _age.dispose();
    _state.dispose();
    _district.dispose();
    _occupation.dispose();
    _income.dispose();
    _education.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('completeProfile'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Info banner ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'These details help Sahayak AI recommend more accurate schemes for you.',
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ── Basic details ──────────────────────────────────────────
          _Label('Basic Details'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _age,
                  hint: 'e.g. 24',
                  label: 'Age',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _gender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  isExpanded: true,
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _state,
                  hint: 'State',
                  label: 'State',
                  icon: Icons.location_city_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  controller: _district,
                  hint: 'District',
                  label: 'District',
                  icon: Icons.location_on_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),

          // ── Economic details ───────────────────────────────────────
          _Label('Economic Details'),
          const SizedBox(height: 10),
          AppTextField(
            controller: _occupation,
            hint: 'Student, Farmer, Entrepreneur...',
            label: 'Occupation',
            icon: Icons.work_outline_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _income,
                  hint: 'Annual ₹',
                  label: 'Annual Income',
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  isExpanded: true,
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _category = v ?? 'General'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(
            controller: _education,
            hint: 'Undergraduate, Diploma...',
            label: 'Education',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 22),

          // ── Additional flags ───────────────────────────────────────
          _Label('Additional Information'),
          const SizedBox(height: 8),
          _ToggleTile(
            title: 'Married',
            subtitle: 'Some schemes are restricted to married individuals',
            icon: Icons.favorite_outline_rounded,
            value: _isMarried,
            onChanged: (v) => setState(() => _isMarried = v),
          ),
          const SizedBox(height: 8),
          _ToggleTile(
            title: 'Person with Disability',
            subtitle: 'Enables disability-specific scheme recommendations',
            icon: Icons.accessible_outlined,
            value: _hasDisability,
            onChanged: (v) => setState(() => _hasDisability = v),
          ),
          const SizedBox(height: 28),

          // ── Save button ────────────────────────────────────────────
          PrimaryButton(
            label: 'Save Profile',
            icon: Icons.check_rounded,
            isLoading: auth.isLoading,
            onPressed: user == null
                ? null
                : () async {
                    await auth.updateUserProfile(user.copyWith(
                      age: int.tryParse(_age.text),
                      gender: _gender,
                      state: _state.text.trim(),
                      district: _district.text.trim(),
                      occupation: _occupation.text.trim(),
                      annualIncome: double.tryParse(_income.text),
                      category: _category,
                      education: _education.text.trim(),
                      isMarried: _isMarried,
                      hasDisability: _hasDisability,
                    ));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('✅ Profile saved! AI recommendations updated.')),
                      );
                      context.go('/home');
                    }
                  },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 11,
          color: AppTheme.muted,
          letterSpacing: 1.0),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.surfaceDark
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: value
                ? AppTheme.primary.withOpacity(0.3)
                : Colors.grey.withOpacity(0.15)),
      ),
      child: SwitchListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        secondary: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 18),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(subtitle,
            style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        value: value,
        activeColor: AppTheme.primary,
        onChanged: onChanged,
      ),
    );
  }
}