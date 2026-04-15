import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/common_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset password', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            const Text('Enter your email and we will send reset instructions if Firebase Auth is configured.'),
            const SizedBox(height: 24),
            AppTextField(controller: _email, hint: 'you@example.com', label: 'Email', icon: Icons.mail_outline),
            const SizedBox(height: 20),
            PrimaryButton(
              label: _sent ? 'Sent' : 'Send Reset Link',
              isLoading: auth.isLoading,
              onPressed: () async {
                final ok = await auth.resetPassword(_email.text);
                if (ok) setState(() => _sent = true);
              },
            ),
            if (_sent)
              TextButton(onPressed: () => context.pop(), child: const Text('Back to login')),
          ],
        ),
      ),
    );
  }
}
