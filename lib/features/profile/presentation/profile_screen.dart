import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/core/theme/app_colors.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:nike_ecommerce/core/providers/core_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Profile Picture & Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.background,
                    backgroundImage: NetworkImage(
                        user?.photoUrl ?? 'https://ui-avatars.com/api/?name=${user?.displayName ?? 'User'}&background=random&size=200'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Guest User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'Not logged in',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      context.push('/edit-profile');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    child: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(height: 1, color: Colors.black12),
            // Menu Items
            _buildProfileMenu(
              icon: Icons.shopping_bag_outlined,
              title: 'Pesanan Saya',
              onTap: () {
                context.push('/orders');
              },
            ),
            _buildProfileMenu(
              icon: Icons.favorite_border_rounded,
              title: 'Favorit',
              onTap: () {
                context.push('/wishlist');
              },
            ),
            _buildProfileMenu(
              icon: Icons.location_on_outlined,
              title: 'Alamat Pengiriman',
              onTap: () {
                context.push('/address');
              },
            ),
            _buildProfileMenu(
              icon: Icons.payment_outlined,
              title: 'Metode Pembayaran',
              onTap: () {
                context.push('/payment');
              },
            ),
            _buildProfileMenu(
              icon: Icons.confirmation_number_outlined,
              title: 'Voucher & Promo',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voucher & Promo - Fitur segera hadir')));
              },
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Colors.black12),
            const SizedBox(height: 16),
            _buildProfileMenu(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifikasi - Fitur segera hadir')));
              },
            ),
            _buildProfileMenu(
              icon: Icons.help_outline,
              title: 'Pusat Bantuan',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pusat Bantuan - Fitur segera hadir')));
              },
            ),
            if (user?.isAdmin == true) ...[
              _buildProfileMenu(
                icon: Icons.settings_outlined,
                title: 'Pengaturan & Admin',
                onTap: () {
                  context.push('/settings');
                },
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Colors.black12),
            ],
            const SizedBox(height: 8),
            _buildProfileMenu(
              icon: Icons.logout,
              title: 'Keluar (Log Out)',
              textColor: Colors.redAccent,
              iconColor: Colors.redAccent,
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true), 
                        child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  ref.read(authControllerProvider.notifier).signOut();
                }
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(icon, size: 26, color: iconColor ?? Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: iconColor != null ? iconColor.withOpacity(0.5) : Colors.grey),
          ],
        ),
      ),
    );
  }
}
