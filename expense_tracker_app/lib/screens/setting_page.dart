import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.go(AppRoutes.home),
                icon: const Icon(Icons.arrow_back),
              ),
              const Text(
                'Pengaturan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 50),
            ],
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Akun'),
            onTap: () {
              // Navigasi ke halaman pengaturan akun
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifikasi'),
            onTap: () {
              // Navigasi ke halaman pengaturan notifikasi
            },
          ),
        ],
      ),
    );
  }
}
