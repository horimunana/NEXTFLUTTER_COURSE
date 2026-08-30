import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:summer_shop/features/auth/provider/auth_provider.dart';
import 'package:summer_shop/features/favorites/provider/favorites_provider.dart';
import 'package:summer_shop/features/home/providers/cart_provider.dart';
import 'package:summer_shop/features/profile/provider/profile_provider.dart';
import 'package:summer_shop/utils/theme.dart';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final favoritesCount = ref.watch(favoritesProvider).length;
    final cartCount = ref.watch(cartCountProvider);
    final auth = ref.watch(authProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: ThemeColor.text,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              children: [
                ClipOval(
                  child: Image.network(
                    profile.avatarUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const CircleAvatar(
                      radius: 32,
                      backgroundColor: ThemeColor.secondary,
                      child: Icon(Icons.person, color: ThemeColor.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeColor.text,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: ThemeColor.grayText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: ThemeColor.grayText),
                          const SizedBox(width: 4),
                          Text(
                            profile.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: ThemeColor.grayText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, color: ThemeColor.grayText),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Stats
          Row(
            children: [
              _StatCard(
                icon: Icons.favorite,
                value: '$favoritesCount',
                label: 'Favorites',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.shopping_cart_outlined,
                value: '$cartCount',
                label: 'In cart',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.receipt_long_outlined,
                value: '3',
                label: 'Orders',
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Menu
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.history, color: ThemeColor.primary),
                  title: const Text('Order history'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined,
                      color: ThemeColor.primary),
                  title: const Text('Payment methods'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined,
                      color: ThemeColor.primary),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    auth.isAuthenticated
                        ? Icons.logout
                        : Icons.login,
                    color: ThemeColor.primary,
                  ),
                  title: Text(auth.isAuthenticated ? 'Logout' : 'Login'),
                  subtitle: Text(auth.isAuthenticated
                      ? 'Signed in as ${auth.email}'
                      : 'Sign in to sync your data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: auth.isAuthenticated
                      ? () => ref.read(authProvider.notifier).logout()
                      : () => context.pushNamed('login'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Member since January 2024',
              style: TextStyle(fontSize: 12, color: ThemeColor.grayText),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Icon(icon, color: ThemeColor.primary, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ThemeColor.text,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: ThemeColor.grayText),
            ),
          ],
        ),
      ),
    );
  }
}