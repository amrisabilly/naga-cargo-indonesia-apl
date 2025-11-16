import 'package:flutter/material.dart';
import 'package:cargo_app/screen/beranda/scanFotoScreen.dart';
import 'package:go_router/go_router.dart';

class FotoKurirScreen extends StatefulWidget {
  final String resi;

  const FotoKurirScreen({super.key, required this.resi});

  @override
  State<FotoKurirScreen> createState() => _FotoKurirScreenState();
}

class _FotoKurirScreenState extends State<FotoKurirScreen> {
  void _onComplete() {
    // Kembali ke beranda setelah selesai
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.18,
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
                    // Header info dengan tombol kembali
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Mode Foto Dokumentasi',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Resi: ${widget.resi}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content area dengan FotoWidget
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
              child: FotoWidget(resi: widget.resi, onComplete: _onComplete),
            ),
          ),
        ],
      ),
    );
  }
}
