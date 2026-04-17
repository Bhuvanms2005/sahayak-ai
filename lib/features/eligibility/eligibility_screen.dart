import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/scheme_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/eligibility_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/scheme_provider.dart';
import '../../providers/tracker_provider.dart';
import '../../widgets/common_widgets.dart';

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key, this.scheme});
  final SchemeModel? scheme;

  @override
  State<EligibilityScreen> createState() => _EligibilityScreenState();
}

class _EligibilityScreenState extends State<EligibilityScreen> {
  final _age = TextEditingController(text: '24');
  final _income = TextEditingController(text: '240000');
  final _occupation = TextEditingController(text: 'Student');
  String _category = 'General';
  String _gender = 'Male';
  SchemeModel? _selected;

  static const _categories = ['General', 'OBC', 'SC', 'ST', 'EWS'];
  static const _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _selected = widget.scheme;
  }

  @override
  void dispose() {
    _age.dispose();
    _income.dispose();
    _occupation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schemes = context.watch<SchemeProvider>().allSchemes;
    final provider = context.watch<EligibilityProvider>();
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();
    final tracker = context.watch<TrackerProvider>();

    _selected ??= schemes.isNotEmpty ? schemes.first : null;

    return Scaffold(
      appBar: AppBar(title: Text(lang.t('eligibilityChecker'))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Intro card ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.fact_check_rounded,
                    color: Colors.white, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Fill in your details to check if you qualify for a scheme.',
                    style: const TextStyle(
                        color: Colors.white, height: 1.5, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // ── Scheme selector ───────────────────────────────────────
          _SectionLabel(text: 'Select Scheme'),
          const SizedBox(height: 8),
          DropdownButtonFormField<SchemeModel>(
            value: _selected,
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.policy_outlined),
            ),
            items: schemes
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14)),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _selected = value),
          ),
          const SizedBox(height: 20),

          // ── Age & Income row ──────────────────────────────────────
          _SectionLabel(text: 'Personal Details'),
          const SizedBox(height: 8),
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
                child: AppTextField(
                  controller: _income,
                  hint: 'Annual ₹',
                  label: 'Annual Income',
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Occupation ────────────────────────────────────────────
          AppTextField(
            controller: _occupation,
            hint: 'Student, Farmer, Entrepreneur...',
            label: 'Occupation',
            icon: Icons.work_outline_rounded,
          ),
          const SizedBox(height: 14),

          // ── Category & Gender row ─────────────────────────────────
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.groups_outlined),
                  ),
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? 'General'),
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
                  items: _genders
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Check button ──────────────────────────────────────────
          PrimaryButton(
            label: lang.t('checkEligibility'),
            icon: Icons.fact_check_rounded,
            isLoading: provider.isChecking,
            onPressed: _selected == null
                ? null
                : () => provider.checkEligibility(
                      scheme: _selected!,
                      user: auth.user,
                      age: int.tryParse(_age.text) ?? 0,
                      income: double.tryParse(_income.text) ?? 0,
                      occupation: _occupation.text,
                      category: _category,
                    ),
          ),
          const SizedBox(height: 22),

          // ── Result card ───────────────────────────────────────────
          if (provider.result != null) ...[
            _ResultCard(
              result: provider.result!,
              scheme: _selected,
              isTracked: _selected != null
                  ? tracker.isTracked(_selected!.id)
                  : false,
              onTrack: _selected == null
                  ? null
                  : () async {
                      await tracker.addApplication(
                        schemeId: _selected!.id,
                        schemeName: _selected!.name,
                        category: _selected!.category,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('✅ Added to Application Tracker!'),
                            action: SnackBarAction(
                                label: 'View',
                                onPressed: () => context.push('/tracker')),
                          ),
                        );
                      }
                    },
              lang: lang,
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 13,
          color: AppTheme.muted,
          letterSpacing: 0.5),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.scheme,
    required this.isTracked,
    required this.onTrack,
    required this.lang,
  });
  final EligibilityResult result;
  final SchemeModel? scheme;
  final bool isTracked;
  final VoidCallback? onTrack;
  final LanguageProvider lang;

  Color _scoreColor() {
    if (result.score >= 70) return AppTheme.teal;
    if (result.score >= 40) return AppTheme.saffron;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.surfaceDark
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score row
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _scoreColor().withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${result.score}%',
                    style: TextStyle(
                        color: _scoreColor(),
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Eligibility Score',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 16)),
                    Text(
                      result.score >= 70
                          ? 'Likely eligible ✅'
                          : result.score >= 40
                              ? 'Partially eligible ⚠️'
                              : 'May not qualify ❌',
                      style: TextStyle(
                          color: _scoreColor(), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Matches
          if (result.matches.isNotEmpty) ...[
            const Text('✅  Positive Signals',
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: AppTheme.teal)),
            const SizedBox(height: 8),
            ...result.matches.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 16, color: AppTheme.teal),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(item,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 12),
          ],

          // Gaps
          if (result.gaps.isNotEmpty) ...[
            const Text('⚠️  Things to Verify',
                style: TextStyle(
                    fontWeight: FontWeight.w900, color: AppTheme.saffron)),
            const SizedBox(height: 8),
            ...result.gaps.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 16, color: AppTheme.saffron),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(item,
                              style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
          ],

          // Track button
          if (scheme != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isTracked ? null : onTrack,
                icon: Icon(
                  isTracked
                      ? Icons.check_circle_rounded
                      : Icons.add_task_rounded,
                  size: 18,
                ),
                label: Text(
                  isTracked
                      ? '${lang.t('addToTracker')} (Already tracking)'
                      : lang.t('addToTracker'),
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      isTracked ? AppTheme.teal : AppTheme.primary,
                  side: BorderSide(
                      color: isTracked ? AppTheme.teal : AppTheme.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}