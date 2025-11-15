import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileKurirScreen extends StatefulWidget {
  const ProfileKurirScreen({super.key});

  @override
  State<ProfileKurirScreen> createState() => _ProfileKurirScreenState();
}

class _ProfileKurirScreenState extends State<ProfileKurirScreen> {
  final Map<String, String> profileData = {
    'nama': 'Ahmad Kurniawan',
    'nomorHp': '+62 812-3456-7890',
    'wilayahTugas': 'Jakarta Selatan',
    'nikKurir': 'KUR001',
    'statusAktif': 'Aktif',
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Header dengan gradient
          Container(
            height: screenHeight * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Header dengan tombol kembali
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => context.go('/beranda'),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Profile Kurir',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer untuk simetri
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Foto Profile Dummy
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: _buildDefaultAvatar(),
                    ),
                    const SizedBox(height: 10),
                    // Nama
                    Text(
                      profileData['nama']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              transform: Matrix4.translationValues(0, -30, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Personal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Column(
                        children: [
                          _buildCompactInfoCard(
                            icon: Icons.phone,
                            title: 'Nomor HP',
                            value: profileData['nomorHp']!,
                          ),
                          const SizedBox(height: 12),
                          _buildCompactInfoCard(
                            icon: Icons.location_on,
                            title: 'Wilayah Tugas',
                            value: profileData['wilayahTugas']!,
                          ),
                          const SizedBox(height: 12),
                          _buildCompactInfoCard(
                            icon: Icons.verified_user,
                            title: 'Status Aktif',
                            value: profileData['statusAktif']!,
                            isStatus: true,
                          ),
                          // Tombol Riwayat
                          GestureDetector(
                            onTap: () {
                              context.go('/riwayat');
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4A90E2,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.history,
                                      color: Color(0xFF4A90E2),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Riwayat Foto Dokumentasi',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _showLogoutConfirmation,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF4A90E2),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.logout,
                                    color: Color(0xFF4A90E2),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Logout',
                                    style: TextStyle(
                                      color: Color(0xFF4A90E2),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Versi Aplikasi 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4A90E2).withOpacity(0.3),
            const Color(0xFF357ABD).withOpacity(0.3),
          ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person, size: 60, color: Color(0xFF4A90E2)),
      ),
    );
  }

  Widget _buildCompactInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isStatus = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4A90E2), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => const KonfirmasiLogoutDialog(),
    );
  }
}

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
