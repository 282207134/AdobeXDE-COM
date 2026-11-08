import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../core/routes.dart';
import '../state/store_controller.dart';
import 'widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.screen,
    required this.controller,
    required this.go,
  });
  final AppScreen screen;
  final StoreController controller;
  final Navigate go;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(text: 'iamdavid@gmail.com');
  final name = TextEditingController(text: 'David Spade');
  final password = TextEditingController(text: 'password123');
  final pin = TextEditingController();
  bool get signup => widget.screen == AppScreen.signup;
  bool get verification => widget.screen == AppScreen.verification;
  @override
  void dispose() {
    for (final c in [email, name, password, pin]) {
      c.dispose();
    }
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    if (verification) {
      if (pin.text.length != 6) {
        showNotice(context, 'Enter a 6-digit demo PIN');
        return;
      }
      widget.go(AppScreen.home);
    } else {
      widget.controller.updateProfile(name.text.trim(), email.text.trim());
      widget.go(signup ? AppScreen.verification : AppScreen.home);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 64),
    decoration: BoxDecoration(
      color: context.panel,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Switch theme',
              onPressed: widget.controller.toggleTheme,
              icon: Icon(
                context.isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            verification
                ? 'Verification'
                : signup
                ? 'Sign Up'
                : 'Welcome',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (!signup)
            Text(
              verification
                  ? 'A 6-Digit PIN has been sent to your email address, enter it below to continue'
                  : 'Sign in to Continue',
              style: TextStyle(fontSize: 16, height: 1.6, color: context.muted),
            ),
          const SizedBox(height: 45),
          if (verification) ...[
            TextFormField(
              key: const Key('verification_pin'),
              controller: pin,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, letterSpacing: 15),
              decoration: const InputDecoration(
                hintText: '000000',
                counterText: '',
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Demo: enter any six digits',
              style: TextStyle(fontSize: 12, color: context.muted),
            ),
          ] else ...[
            if (signup) StoreField('Name', name),
            StoreField(
              'Email',
              email,
              type: TextInputType.emailAddress,
              validator: (v) =>
                  v != null && RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)
                  ? null
                  : 'Enter a valid email',
            ),
            StoreField(
              'Password',
              password,
              obscure: true,
              validator: (v) =>
                  (v?.length ?? 0) >= 6 ? null : 'Use at least 6 characters',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showNotice(
                  context,
                  'Demo account: use any valid email and a 6-character password.',
                ),
                child: const Text('Forgot Password?'),
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            key: const Key('auth_submit'),
            onPressed: submit,
            child: Text(
              verification
                  ? 'SUBMIT'
                  : signup
                  ? 'SIGN UP'
                  : 'SIGN IN',
            ),
          ),
          if (!verification && !signup) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(child: Text('-OR-')),
            ),
            for (final provider in ['Google', 'Facebook'])
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  onPressed: () => showNotice(
                    context,
                    '$provider sign-in is not connected. Use the demo email sign-in above.',
                  ),
                  child: Text('Sign In with $provider'),
                ),
              ),
          ],
          if (!verification)
            TextButton(
              onPressed: () =>
                  widget.go(signup ? AppScreen.welcome : AppScreen.signup),
              child: Text(
                signup
                    ? 'Already have an account? Sign In'
                    : 'New here? Create an account',
              ),
            ),
          if (verification)
            TextButton(
              onPressed: () =>
                  showNotice(context, 'Demo PIN ready. Enter any six digits.'),
              child: const Text('Resend PIN'),
            ),
        ],
      ),
    ),
  );
}
