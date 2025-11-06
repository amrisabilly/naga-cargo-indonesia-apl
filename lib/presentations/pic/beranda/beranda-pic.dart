import 'package:flutter/material.dart';

class BerandaPicScreen extends StatefulWidget {
  const BerandaPicScreen({super.key});

  @override
  State<BerandaPicScreen> createState() => _BerandaPicScreenState();
}

class _BerandaPicScreenState extends State<BerandaPicScreen> {
  final TextEditingController _alamatController = TextEditingController();
  bool _hasScanResult = false;
  String _scannedCode = '';
  String? _bastImageUrl;
  bool _isLoading = false;

  void _scanBast() {
    setState(() {
      _isLoading = true;
    });

    // Simulasi loading scan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text(
                  'Memindai BAST...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
    );

    // Simulasi delay scan
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Tutup loading dialog

      setState(() {
        _isLoading = false;
        _hasScanResult = true;
        _scannedCode =
            'BAST-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
        _bastImageUrl =
            'https://picsum.photos/400/600?random=${DateTime.now().millisecondsSinceEpoch}';
      });
    });
  }

  void _retakeBast() {
    setState(() {
      _hasScanResult = false;
      _scannedCode = '';
      _bastImageUrl = null;
    });
  }

  void _submitData() {
    if (_alamatController.text.trim().isEmpty) {
      return;
    }

    if (!_hasScanResult) {
      return;
    }

    // Simulasi submit
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text(
                  'Menyimpan data...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      // Reset form
      setState(() {
        _hasScanResult = false;
        _scannedCode = '';
        _bastImageUrl = null;
        _alamatController.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Header dengan gradient - lebih kompak
          Container(
            height: screenHeight * 0.25, // Dikurangi dari 0.3 ke 0.25
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info - lebih kompak
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfilePicScreen(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 22, // Dikurangi dari 25
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF4A90E2),
                              size: 26, // Dikurangi dari 30
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13, // Dikurangi dari 14
                                ),
                              ),
                              Text(
                                'PIC Naga Cargo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17, // Dikurangi dari 18
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 24, // Dikurangi dari 28
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Title - lebih kompak
                    const Text(
                      'Scan BAST',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20, // Dikurangi dari 22
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Pindai dokumen BAST untuk memproses pengiriman',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ), // Dikurangi dari 14
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content dengan keyboard handling
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              transform: Matrix4.translationValues(
                0,
                -20,
                0,
              ), // Dikurangi dari -30
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    15,
                    20,
                    120,
                  ), // Bottom padding untuk button
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Scan BAST Section - lebih kompak
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14), // Dikurangi dari 16
                        decoration: BoxDecoration(
                          color:
                              _hasScanResult
                                  ? Colors.green[50]
                                  : Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                _hasScanResult
                                    ? Colors.green[200]!
                                    : Colors.blue[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _hasScanResult
                                      ? Icons.check_circle
                                      : Icons.qr_code_scanner,
                                  color:
                                      _hasScanResult
                                          ? Colors.green[700]
                                          : Colors.blue[700],
                                  size: 20, // Dikurangi dari 22
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _hasScanResult
                                        ? 'BAST Berhasil Dipindai'
                                        : 'Siap Memindai BAST',
                                    style: TextStyle(
                                      fontSize: 14, // Dikurangi dari 15
                                      fontWeight: FontWeight.w600,
                                      color:
                                          _hasScanResult
                                              ? Colors.green[700]
                                              : Colors.blue[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_hasScanResult) ...[
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(
                                  10,
                                ), // Dikurangi dari 12
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Kode BAST:',
                                      style: TextStyle(
                                        fontSize: 11, // Dikurangi dari 12
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      _scannedCode,
                                      style: const TextStyle(
                                        fontSize: 13, // Dikurangi dari 14
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      // BAST Image Preview - kondisional dan lebih kompak
                      if (_hasScanResult && _bastImageUrl != null) ...[
                        const Text(
                          'Preview BAST',
                          style: TextStyle(
                            fontSize: 15, // Dikurangi dari 16
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 150, // Dikurangi dari 180
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green[300]!,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.network(
                                  _bastImageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],

                      // Alamat Tujuan Input
                      const Text(
                        'Alamat Tujuan',
                        style: TextStyle(
                          fontSize: 15, // Dikurangi dari 16
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: _alamatController,
                          onChanged: (value) {
                            setState(() {}); // Update button state
                          },
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Masukkan alamat tujuan lengkap...',
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(
                              14,
                            ), // Dikurangi dari 16
                          ),
                        ),
                      ),

                      const SizedBox(height: 20), // Space untuk scroll
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Sheet untuk action buttons
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Scan/Retake Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      _isLoading
                          ? null
                          : (_hasScanResult ? _retakeBast : _scanBast),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _hasScanResult
                            ? Colors.orange
                            : const Color(0xFF4A90E2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _hasScanResult ? Icons.refresh : Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 18, // Dikurangi dari 20
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _hasScanResult ? 'Scan Ulang BAST' : 'Scan BAST',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14, // Dikurangi dari 15
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_hasScanResult &&
                              _alamatController.text.trim().isNotEmpty)
                          ? _submitData
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.send,
                        color:
                            (_hasScanResult &&
                                    _alamatController.text.trim().isNotEmpty)
                                ? Colors.white
                                : Colors.grey[600],
                        size: 18, // Dikurangi dari 20
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kirim Data',
                        style: TextStyle(
                          color:
                              (_hasScanResult &&
                                      _alamatController.text.trim().isNotEmpty)
                                  ? Colors.white
                                  : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14, // Dikurangi dari 15
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }
}

// Profile PIC Screen placeholder
class ProfilePicScreen extends StatelessWidget {
  const ProfilePicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile PIC'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'Profile PIC Screen\n(Akan dibuat serupa dengan Profile Kurir)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
