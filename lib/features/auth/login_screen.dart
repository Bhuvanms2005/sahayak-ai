import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'demo@sahayak.ai');
  final _password = TextEditingController(text: 'password123');

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 28),
                Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('Continue your scheme discovery journey.', style: TextStyle(color: AppTheme.muted)),
                const SizedBox(height: 30),
                AppTextField(
                  controller: _email,
                  hint: 'you@example.com',
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _password,
                  hint: 'Minimum 6 characters',
                  label: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  validator: (v) => v == null || v.length < 6 ? 'Password is too short' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () => context.push('/forgot-password'), child: const Text('Forgot password?')),
                ),
                if (auth.errorMessage != null) _ErrorText(auth.errorMessage!),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: 'Login',
                  isLoading: auth.isLoading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final ok = await auth.signIn(email: _email.text, password: _password.text);
                    if (ok && mounted) context.go('/home');
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New here?'),
                    TextButton(onPressed: () => context.push('/signup'), child: const Text('Create account')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(text, style: const TextStyle(color: AppTheme.coral, fontWeight: FontWeight.w700)),
      );
}
