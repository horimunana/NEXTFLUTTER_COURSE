import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/auth/provider/auth_provider.dart';
import 'package:summer_shop/utils/theme.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final auth = ref.watch(authProvider);

    // Navigate home as soon as login succeeds.
    useEffect(() {
      if (auth.isAuthenticated) {
        context.go('/');
      }
      return null;
    }, [auth.isAuthenticated]);

    Future<void> submit() async {
      if (!formKey.currentState!.validate()) return;
      await ref.read(authProvider.notifier).login(
            email: emailController.text.trim(),
            password: passwordController.text,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: ThemeColor.text,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Sign in to continue shopping',
                  style: TextStyle(color: ThemeColor.grayText),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Email is required'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : null,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: auth.isLoading ? null : submit,
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign In'),
                ),
                TextButton(
                  onPressed: () => context.goNamed('register'),
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(color: ThemeColor.primary),
                  ),
                ),
                if (auth.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      auth.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent),
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