import 'package:flutter/material.dart';
import 'package:cargo_app/screen/profile/profileScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controller/loginController.dart';
import '../../controller/berandaController.dart';

class BerandaKurirScreen extends StatefulWidget {
  const BerandaKurirScreen({super.key});

  @override
  State<BerandaKurirScreen> createState() => _BerandaKurirScreenState();
}

class _BerandaKurirScreenState extends State<BerandaKurirScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Tambahkan method ini
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    if (mounted) {
      final loginController = context.read<LoginController>();
      final berandaController = context.read<BerandaController>();

      final idKurir = loginController.userData?['id_user'];
      if (idKurir == null || idKurir == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID Kurir tidak valid, silakan login ulang.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      berandaController.loadOrderByDaerah(idKurir: idKurir);
    }
  }

  void _performSearch(String query) {
    if (mounted) {
      final berandaController = context.read<BerandaController>();

      setState(() {
        _isSearching = query.isNotEmpty;
      });

      if (query.isNotEmpty) {
        berandaController.filterOrders(query.trim());
      } else {
        berandaController.clearFilter();
      }
    }
  }

  void _navigateToFoto(String resi) {
    context.go('/fotoScreen', extra: {'resi': resi});
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
            ? screenHeight * 0.28
            : isMediumScreen
            ? screenHeight * 0.3
            : screenHeight * 0.32;
    final horizontalPadding = screenWidth * 0.05;
    final avatarRadius =
        isSmallScreen
            ? 22.0
            : isMediumScreen
            ? 25.0
            : 28.0;
    final welcomeFontSize =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 14.0
            : 15.0;
    final nameFontSize =
        isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 18.0
            : 20.0;
    final searchBarPadding =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 15.0
            : 18.0;

    return Scaffold(
      body: Consumer<LoginController>(
        builder: (context, loginController, _) {
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header info
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go('/profile');
                              },
                              child: CircleAvatar(
                                radius: avatarRadius,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: const Color(0xFF4A90E2),
                                  size: avatarRadius * 1.2,
                                ),
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 10 : 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: welcomeFontSize,
                                    ),
                                  ),
                                  Text(
                                    _formatName(
                                      loginController.userData?['nama'],
                                    ),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: nameFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height:
                              isSmallScreen
                                  ? 16
                                  : isMediumScreen
                                  ? 24
                                  : 30,
                        ),

                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _performSearch,
                            style: TextStyle(
                              fontSize:
                                  isSmallScreen
                                      ? 13
                                      : isMediumScreen
                                      ? 14
                                      : 15,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari nomor resi atau alamat...',
                              hintStyle: TextStyle(
                                fontSize:
                                    isSmallScreen
                                        ? 12
                                        : isMediumScreen
                                        ? 13
                                        : 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: const Color(0xFF4A90E2),
                                size:
                                    isSmallScreen
                                        ? 20
                                        : isMediumScreen
                                        ? 22
                                        : 24,
                              ),
                              suffixIcon:
                                  _searchController.text.isNotEmpty
                                      ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _isSearching = false;
                                          });
                                          if (mounted) {
                                            context
                                                .read<BerandaController>()
                                                .clearFilter();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.clear,
                                          size:
                                              isSmallScreen
                                                  ? 18
                                                  : isMediumScreen
                                                  ? 20
                                                  : 22,
                                        ),
                                      )
                                      : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: searchBarPadding,
                                vertical: searchBarPadding,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Content area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -20, 0),
                  child: _buildSearchContent(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;

    return Consumer<BerandaController>(
      builder: (context, berandaController, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16.0 : 20.0,
            vertical: isSmallScreen ? 12.0 : 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    isSmallScreen
                        ? 12
                        : isMediumScreen
                        ? 16
                        : 20,
              ),
              if (!_isSearching) ...[
                Center(
                  child: Text(
                    'Pencarian Data Resi',
                    style: TextStyle(
                      fontSize:
                          isSmallScreen
                              ? 18
                              : isMediumScreen
                              ? 20
                              : 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height:
                      isSmallScreen
                          ? 20
                          : isMediumScreen
                          ? 25
                          : 30,
                ),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search,
                        size:
                            isSmallScreen
                                ? 60
                                : isMediumScreen
                                ? 70
                                : 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height:
                            isSmallScreen
                                ? 12
                                : isMediumScreen
                                ? 16
                                : 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Ketik nomor resi atau alamat untuk mencari data pengiriman',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize:
                                isSmallScreen
                                    ? 13
                                    : isMediumScreen
                                    ? 15
                                    : 16,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'Rekomendasi (${berandaController.filteredOrders.length})',
                  style: TextStyle(
                    fontSize:
                        isSmallScreen
                            ? 16
                            : isMediumScreen
                            ? 17
                            : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(
                  height:
                      isSmallScreen
                          ? 10
                          : isMediumScreen
                          ? 12
                          : 15,
                ),
                Expanded(
                  child:
                      berandaController.filteredOrders.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size:
                                      isSmallScreen
                                          ? 50
                                          : isMediumScreen
                                          ? 55
                                          : 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: isSmallScreen ? 10 : 15),
                                Text(
                                  'Data tidak ditemukan',
                                  style: TextStyle(
                                    fontSize:
                                        isSmallScreen
                                            ? 14
                                            : isMediumScreen
                                            ? 15
                                            : 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: berandaController.filteredOrders.length,
                            itemBuilder: (context, index) {
                              final data =
                                  berandaController.filteredOrders[index];
                              return _buildResiCard(data);
                            },
                          ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildResiCard(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;

    return Container(
      margin: EdgeInsets.only(
        bottom:
            isSmallScreen
                ? 10
                : isMediumScreen
                ? 12
                : 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isSmallScreen
              ? 12.0
              : isMediumScreen
              ? 14.0
              : 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data['resi'] ?? 'N/A',
                    style: TextStyle(
                      fontSize:
                          isSmallScreen
                              ? 14
                              : isMediumScreen
                              ? 15
                              : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4A90E2),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 10,
                    vertical: isSmallScreen ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    data['status'] ?? 'Proses',
                    style: TextStyle(
                      fontSize:
                          isSmallScreen
                              ? 10
                              : isMediumScreen
                              ? 11
                              : 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height:
                  isSmallScreen
                      ? 8
                      : isMediumScreen
                      ? 10
                      : 12,
            ),
            _buildInfoRow('Alamat', data['alamat'] ?? 'N/A'),
            SizedBox(
              height:
                  isSmallScreen
                      ? 10
                      : isMediumScreen
                      ? 12
                      : 15,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _navigateToFoto(data['resi'] ?? '');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical:
                        isSmallScreen
                            ? 10
                            : isMediumScreen
                            ? 11
                            : 12,
                  ),
                ),
                child: Text(
                  'Mulai Foto Dokumentasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize:
                        isSmallScreen
                            ? 13
                            : isMediumScreen
                            ? 14
                            : 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;
    final fontSize =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 13.0
            : 14.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isSmallScreen ? 60 : 80,
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, color: Colors.black54),
          ),
        ),
        Text(': ', style: TextStyle(fontSize: fontSize, color: Colors.black54)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: fontSize, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
