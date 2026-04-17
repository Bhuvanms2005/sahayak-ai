import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final lang = context.watch<LanguageProvider>();

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

                // ── Logo ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.travel_explore_rounded,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 28),

                Text(
                  'Welcome back',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Continue your scheme discovery journey.',
                  style: TextStyle(color: AppTheme.muted),
                ),
                const SizedBox(height: 30),

                // ── Email ─────────────────────────────────────────
                AppTextField(
                  controller: _email,
                  hint: 'you@example.com',
                  label: 'Email',
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || !v.contains('@')
                          ? 'Enter a valid email'
                          : null,
                ),
                const SizedBox(height: 14),

                // ── Password ──────────────────────────────────────
                TextFormField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  validator: (v) =>
                      v == null || v.length < 6
                          ? 'Password is too short'
                          : null,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Minimum 6 characters',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    child: const Text('Forgot password?'),
                  ),
                ),

                if (auth.errorMessage != null) _ErrorText(auth.errorMessage!),
                const SizedBox(height: 10),

                PrimaryButton(
                  label: 'Login',
                  isLoading: auth.isLoading,
                  onPressed: () async {
                    auth.clearError();
                    if (!_formKey.currentState!.validate()) return;
                    final ok = await auth.signIn(
                        email: _email.text, password: _password.text);
                    if (ok && mounted) context.go('/home');
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('New here?'),
                    TextButton(
                      onPressed: () => context.push('/signup'),
                      child: const Text('Create account'),
                    ),
                  ],
                ),

                // ── Language selector hint ────────────────────────
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: () =>
                        context.push('/language-select'),
                    icon: Text(lang.currentLanguage.flag,
                        style: const TextStyle(fontSize: 18)),
                    label: Text(
                      '${lang.currentLanguage.nativeName} · Change language',
                      style: const TextStyle(
                          color: AppTheme.muted, fontSize: 13),
                    ),
                  ),
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
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.error.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.error.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  color: AppTheme.error, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(text,
                    style: const TextStyle(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ],
          ),
        ),
      );
}