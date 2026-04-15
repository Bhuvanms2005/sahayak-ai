import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../models/scheme_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/eligibility_provider.dart';
import '../../providers/scheme_provider.dart';
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
  final _category = TextEditingController(text: 'General');
  SchemeModel? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.scheme;
  }

  @override
  Widget build(BuildContext context) {
    final schemes = context.watch<SchemeProvider>().allSchemes;
    final provider = context.watch<EligibilityProvider>();
    final auth = context.watch<AuthProvider>();
    _selected ??= schemes.isNotEmpty ? schemes.first : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Eligibility Checker')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownButtonFormField<SchemeModel>(
            value: _selected,
            items: schemes.map((scheme) => DropdownMenuItem(value: scheme, child: Text(scheme.name, overflow: TextOverflow.ellipsis))).toList(),
            onChanged: (value) => setState(() => _selected = value),
            decoration: const InputDecoration(labelText: 'Select scheme'),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: AppTextField(controller: _age, hint: 'Age', label: 'Age', keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: AppTextField(controller: _income, hint: 'Annual income', label: 'Income', keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 14),
          AppTextField(controller: _occupation, hint: 'Student, farmer, entrepreneur...', label: 'Occupation', icon: Icons.work_outline),
          const SizedBox(height: 14),
          AppTextField(controller: _category, hint: 'General, OBC, SC, ST...', label: 'Category', icon: Icons.groups_outlined),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Check Eligibility',
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
                      category: _category.text,
                    ),
          ),
          const SizedBox(height: 22),
          if (provider.result != null) _ResultCard(result: provider.result!),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});
  final EligibilityResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${result.score}% likely match', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primary, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          const Text('Positive signals', style: TextStyle(fontWeight: FontWeight.w900)),
          ...result.matches.map((item) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.check_circle, color: AppTheme.teal), title: Text(item))),
          const Text('Things to verify', style: TextStyle(fontWeight: FontWeight.w900)),
          ...result.gaps.map((item) => ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.info_outline, color: AppTheme.saffron), title: Text(item))),
        ],
      ),
    );
  }
}
