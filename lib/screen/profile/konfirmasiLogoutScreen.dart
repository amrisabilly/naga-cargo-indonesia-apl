import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KonfirmasiLogoutDialog extends StatelessWidget {
  const KonfirmasiLogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.logout, color: Color(0xFF4A90E2), size: 28),
          SizedBox(width: 12),
          Text('Konfirmasi Logout'),
        ],
      ),
      content: const Text(
        'Apakah Anda yakin ingin keluar dari aplikasi?',
        style: TextStyle(fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Batal',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.go('/login');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
