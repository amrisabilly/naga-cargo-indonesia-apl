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
      
      if (loginController.userData?['id_user'] != null) {
        berandaController.loadOrderByDaerah(
          idKurir: loginController.userData?['id_user'] ?? 0,
        );
      }
    }
  }

  void _performSearch(String query) {
    if (mounted) {
      final berandaController = context.read<BerandaController>();
      
      setState(() {
        _isSearching = query.isNotEmpty;
      });

      if (query.isNotEmpty) {
        // Filter data yang sudah di-load, bukan search ke API
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

    return Scaffold(
      body: Consumer<LoginController>(
        builder: (context, loginController, _) {
          return Column(
            children: [
              // Header dengan gradient
              Container(
                height: screenHeight * 0.3,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header info
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.go('/profile');
                              },
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: Color(0xFF4A90E2),
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang,',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    loginController.userData?['nama'] ?? 'Kurir',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
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

                        const SizedBox(height: 30),

                        // Search bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _performSearch,
                            decoration: InputDecoration(
                              hintText: 'Cari nomor resi atau alamat...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color(0xFF4A90E2),
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _isSearching = false;
                                      });
                                      if (mounted) {
                                        context.read<BerandaController>().clearFilter();
                                      }
                                    },
                                    icon: const Icon(Icons.clear),
                                  )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
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
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  transform: Matrix4.translationValues(0, -30, 0),
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
    return Consumer<BerandaController>(
      builder: (context, berandaController, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (!_isSearching) ...[
                // Tampilkan pesan awal ketika belum search
                Center(
                  child: Text(
                    'Pencarian Data Resi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Icon(Icons.search, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                      Text(
                        'Ketik nomor resi atau alamat untuk mencari data pengiriman',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Tampilkan hasil filter sebagai rekomendasi
                Text(
                  'Rekomendasi (${berandaController.filteredOrders.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: berandaController.filteredOrders.isEmpty
                      ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Data tidak ditemukan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: berandaController.filteredOrders.length,
                        itemBuilder: (context, index) {
                          final data = berandaController.filteredOrders[index];
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
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['resi'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Text(
                    data['status'] ?? 'Proses',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Alamat', data['alamat'] ?? 'N/A'),
            const SizedBox(height: 15),
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Mulai Foto Dokumentasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
        const Text(': ', style: TextStyle(color: Colors.black54)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
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