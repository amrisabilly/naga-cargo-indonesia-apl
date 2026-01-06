import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controller/profileController.dart';
import '../../controller/loginController.dart';

class ProfileKurirScreen extends StatefulWidget {
  const ProfileKurirScreen({super.key});

  @override
  State<ProfileKurirScreen> createState() => _ProfileKurirScreenState();
}

class _ProfileKurirScreenState extends State<ProfileKurirScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileController>().loadProfileData();
    });
  }

  String _formatName(String? name) {
    if (name == null || name.isEmpty) return 'Kurir';
    return name
        .split(' ')
        .map(
          (word) =>
              word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;

    // Responsive sizing
    final headerHeight =
        isSmallScreen
            ? screenHeight * 0.22
            : isMediumScreen
            ? screenHeight * 0.25
            : screenHeight * 0.28;
    final horizontalPadding = screenWidth * 0.05;
    final iconSize =
        isSmallScreen
            ? 20.0
            : isMediumScreen
            ? 22.0
            : 24.0;
    final titleFontSize =
        isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 18.0
            : 20.0;
    final nameFontSize =
        isSmallScreen
            ? 20.0
            : isMediumScreen
            ? 24.0
            : 28.0;
    final sectionTitleSize =
        isSmallScreen
            ? 15.0
            : isMediumScreen
            ? 16.0
            : 18.0;
    final cardPadding =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 14.0
            : 16.0;
    final iconContainerSize =
        isSmallScreen
            ? 36.0
            : isMediumScreen
            ? 38.0
            : 40.0;
    final iconInnerSize = isSmallScreen ? 18.0 : 20.0;
    final labelFontSize = isSmallScreen ? 11.0 : 12.0;
    final valueFontSize = isSmallScreen ? 13.0 : 14.0;
    final buttonFontSize =
        isSmallScreen
            ? 14.0
            : isMediumScreen
            ? 15.0
            : 16.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<ProfileController>(
        builder: (context, profileController, child) {
          return Column(
            children: [
              // Header dengan gradient
              Container(
                height: headerHeight,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: isSmallScreen ? 12.0 : 16.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Header dengan tombol kembali
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                try {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  } else {
                                    context.go('/beranda_kurir');
                                  }
                                } catch (e) {
                                  print('[DEBUG] Error navigating back: $e');
                                  context.go('/beranda_kurir');
                                }
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: iconSize,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Expanded(
                              child: Text(
                                'Profile Kurir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Nama Kurir
                        Text(
                          _formatName(profileController.namaKurir),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: nameFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 20
                                  : isMediumScreen
                                  ? 30
                                  : 40,
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
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(
                    0,
                    isSmallScreen
                        ? -20
                        : isMediumScreen
                        ? -25
                        : -30,
                    0,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      isSmallScreen
                          ? 20
                          : isMediumScreen
                          ? 25
                          : 30,
                      horizontalPadding,
                      isSmallScreen ? 16 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Personal',
                          style: TextStyle(
                            fontSize: sectionTitleSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 10 : 15),
                        Expanded(
                          child: Column(
                            children: [
                              _buildCompactInfoCard(
                                icon: Icons.phone,
                                title: 'Nomor HP',
                                value: profileController.noHp,
                                cardPadding: cardPadding,
                                iconContainerSize: iconContainerSize,
                                iconInnerSize: iconInnerSize,
                                labelFontSize: labelFontSize,
                                valueFontSize: valueFontSize,
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              _buildCompactInfoCard(
                                icon: Icons.location_on,
                                title: 'Wilayah Tugas',
                                value: profileController.daerah,
                                cardPadding: cardPadding,
                                iconContainerSize: iconContainerSize,
                                iconInnerSize: iconInnerSize,
                                labelFontSize: labelFontSize,
                                valueFontSize: valueFontSize,
                              ),
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              _buildCompactInfoCard(
                                icon: Icons.verified_user,
                                title: 'Status Aktif',
                                value: profileController.status,
                                isStatus: true,
                                cardPadding: cardPadding,
                                iconContainerSize: iconContainerSize,
                                iconInnerSize: iconInnerSize,
                                labelFontSize: labelFontSize,
                                valueFontSize: valueFontSize,
                              ),
                              // Tombol Riwayat
                              GestureDetector(
                                onTap: () {
                                  context.go('/riwayat_kurir');
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(cardPadding),
                                  margin: EdgeInsets.only(
                                    top: isSmallScreen ? 8 : 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                    ),
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
                                        width: iconContainerSize,
                                        height: iconContainerSize,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF4A90E2,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.history,
                                          color: const Color(0xFF4A90E2),
                                          size: iconInnerSize,
                                        ),
                                      ),
                                      SizedBox(width: isSmallScreen ? 10 : 12),
                                      Expanded(
                                        child: Text(
                                          'Riwayat Pengiriman (${profileController.totalRiwayat})',
                                          style: TextStyle(
                                            fontSize: valueFontSize,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.grey,
                                        size: iconInnerSize,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Logout Button
                              SizedBox(
                                width: double.infinity,
                                height:
                                    isSmallScreen
                                        ? 44
                                        : isMediumScreen
                                        ? 48
                                        : 52,
                                child: OutlinedButton(
                                  onPressed: _showLogoutConfirmation,
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: Color(0xFF4A90E2),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: const Color(0xFF4A90E2),
                                        size: iconInnerSize,
                                      ),
                                      SizedBox(width: isSmallScreen ? 6 : 10),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: const Color(0xFF4A90E2),
                                          fontWeight: FontWeight.w600,
                                          fontSize: buttonFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 10 : 15),
                              Text(
                                'Versi Aplikasi 1.0.0',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 12,
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
          );
        },
      ),
    );
  }

  Widget _buildCompactInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isStatus = false,
    required double cardPadding,
    required double iconContainerSize,
    required double iconInnerSize,
    required double labelFontSize,
    required double valueFontSize,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(cardPadding),
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
            width: iconContainerSize,
            height: iconContainerSize,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4A90E2),
              size: iconInnerSize,
            ),
          ),
          SizedBox(width: cardPadding * 0.75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: labelFontSize,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: valueFontSize,
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;

    showDialog(
      context: context,
      builder:
          (dialogContext) => KonfirmasiLogoutDialog(
            onLogoutConfirmed: () {
              Navigator.pop(dialogContext);
              _performLogout();
            },
            isSmallScreen: isSmallScreen,
            isMediumScreen: isMediumScreen,
          ),
    );
  }

  Future<void> _performLogout() async {
    try {
      await context.read<LoginController>().logout();

      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      print('[DEBUG] Error during logout: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class KonfirmasiLogoutDialog extends StatelessWidget {
  final VoidCallback onLogoutConfirmed;
  final bool isSmallScreen;
  final bool isMediumScreen;

  const KonfirmasiLogoutDialog({
    super.key,
    required this.onLogoutConfirmed,
    required this.isSmallScreen,
    required this.isMediumScreen,
  });

  @override
  Widget build(BuildContext context) {
    final titleFontSize =
        isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 18.0
            : 20.0;
    final contentFontSize =
        isSmallScreen
            ? 13.0
            : isMediumScreen
            ? 14.0
            : 16.0;
    final buttonFontSize =
        isSmallScreen
            ? 13.0
            : isMediumScreen
            ? 14.0
            : 15.0;
    final iconSize =
        isSmallScreen
            ? 22.0
            : isMediumScreen
            ? 24.0
            : 28.0;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titlePadding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      contentPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 8 : 12,
      ),
      actionsPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      title: Row(
        children: [
          Icon(Icons.logout, color: const Color(0xFF4A90E2), size: iconSize),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Text(
              'Konfirmasi Logout',
              style: TextStyle(fontSize: titleFontSize),
            ),
          ),
        ],
      ),
      content: Text(
        'Apakah Anda yakin ingin keluar dari aplikasi?',
        style: TextStyle(fontSize: contentFontSize),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: buttonFontSize,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onLogoutConfirmed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4A90E2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 20,
              vertical: isSmallScreen ? 8 : 10,
            ),
          ),
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: buttonFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
