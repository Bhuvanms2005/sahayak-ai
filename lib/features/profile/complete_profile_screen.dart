import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
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
  final _category = TextEditingController(text: 'General');
  final _education = TextEditingController(text: 'Undergraduate');

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('These details help Sahayak AI recommend schemes more accurately.'),
          const SizedBox(height: 18),
          AppTextField(controller: _age, hint: 'Age', label: 'Age', keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          AppTextField(controller: _state, hint: 'State', label: 'State'),
          const SizedBox(height: 12),
          AppTextField(controller: _district, hint: 'District', label: 'District'),
          const SizedBox(height: 12),
          AppTextField(controller: _occupation, hint: 'Occupation', label: 'Occupation'),
          const SizedBox(height: 12),
          AppTextField(controller: _income, hint: 'Annual income', label: 'Annual Income', keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          AppTextField(controller: _category, hint: 'Category', label: 'Category'),
          const SizedBox(height: 12),
          AppTextField(controller: _education, hint: 'Education', label: 'Education'),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Save Profile',
            icon: Icons.check_rounded,
            onPressed: user == null
                ? null
                : () async {
                    await auth.updateUserProfile(user.copyWith(
                      age: int.tryParse(_age.text),
                      state: _state.text,
                      district: _district.text,
                      occupation: _occupation.text,
                      annualIncome: double.tryParse(_income.text),
                      category: _category.text,
                      education: _education.text,
                    ));
                    if (context.mounted) context.go('/home');
                  },
          ),
        ],
      ),
    );
  }
}
