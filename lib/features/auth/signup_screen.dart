import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create your account', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Build a profile once and get smarter recommendations.'),
                const SizedBox(height: 28),
                AppTextField(controller: _name, hint: 'Full name', label: 'Name', icon: Icons.person_outline, validator: (v) => v == null || v.isEmpty ? 'Name is required' : null),
                const SizedBox(height: 14),
                AppTextField(controller: _email, hint: 'you@example.com', label: 'Email', icon: Icons.mail_outline, validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null),
                const SizedBox(height: 14),
                AppTextField(controller: _password, hint: 'Minimum 6 characters', label: 'Password', icon: Icons.lock_outline, obscureText: true, validator: (v) => v == null || v.length < 6 ? 'Use at least 6 characters' : null),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Create Account',
                  isLoading: auth.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final ok = await auth.signUp(name: _name.text, email: _email.text, password: _password.text);
                    if (ok && mounted) context.go('/complete-profile');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
