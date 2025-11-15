import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatKurirScreen extends StatelessWidget {
  const RiwayatKurirScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy riwayat foto dokumentasi
    final List<Map<String, String>> historyData = [
      {
        'resi': 'NC001234567',
        'alamat': 'Jl. Merdeka No. 123, Surabaya',
        'status': 'Selesai Foto',
        'tanggal': '2024-06-01 10:15',
      },
      {
        'resi': 'NC001234568',
        'alamat': 'Jl. Malioboro No. 45, Yogyakarta',
        'status': 'Selesai Foto',
        'tanggal': '2024-06-01 09:30',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Foto'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/profile');
          },
        ),
      ),
      body:
          historyData.isEmpty
              ? const Center(
                child: Text(
                  'Belum ada riwayat dokumentasi.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final data = historyData[index];
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
                                data['resi']!,
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
                                  data['status']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data['alamat']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                data['tanggal']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
