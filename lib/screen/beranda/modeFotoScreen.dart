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
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isSmallScreen = screenHeight < 650;
    final isMediumScreen = screenHeight >= 650 && screenHeight <= 800;

    // Responsive sizing
    final headerHeight =
        isSmallScreen
            ? screenHeight * 0.15
            : isMediumScreen
            ? screenHeight * 0.17
            : screenHeight * 0.18;
    final horizontalPadding = screenWidth * 0.05;
    final iconSize =
        isSmallScreen
            ? 24.0
            : isMediumScreen
            ? 26.0
            : 28.0;
    final titleFontSize =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 13.0
            : 14.0;
    final resiFontSize =
        isSmallScreen
            ? 15.0
            : isMediumScreen
            ? 17.0
            : 18.0;

    return Scaffold(
      body: Column(
        children: [
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
                    // Header info dengan tombol kembali
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
                        SizedBox(width: isSmallScreen ? 8 : 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Foto Dokumentasi',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: titleFontSize,
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 2 : 4),
                              Text(
                                'Resi: ${widget.resi}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: resiFontSize,
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
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              transform: Matrix4.translationValues(
                0,
                isSmallScreen
                    ? -15
                    : isMediumScreen
                    ? -20
                    : -30,
                0,
              ),
              child: FotoWidget(resi: widget.resi, onComplete: _onComplete),
            ),
          ),
        ],
      ),
    );
  }
}
