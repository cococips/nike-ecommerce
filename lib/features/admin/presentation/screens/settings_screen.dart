import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Admin Dashboard'),
            subtitle: const Text('Manage products, stock, and pricing'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/admin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Manage Orders'),
            subtitle: const Text('Update order status and view all orders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              context.push('/admin/orders');
            },
          ),
          // More settings can be added here in the future
        ],
      ),
    );
  }
}
