import 'package:flutter/material.dart';
import 'package:cargo_app/presentations/kurir/beranda/foto-preview.dart';

class FotoWidget extends StatefulWidget {
  final String resi;
  final VoidCallback onComplete;

  const FotoWidget({super.key, required this.resi, required this.onComplete});

  @override
  State<FotoWidget> createState() => _FotoWidgetState();
}

class _FotoWidgetState extends State<FotoWidget> {
  int currentStep = 0;
  List<bool> photoTaken = List.filled(7, false);
  List<String?> photoUrls = List.filled(7, null);

  final List<Map<String, dynamic>> photoSteps = [
    {
      'title': 'Tampak Keseluruhan',
      'description': 'Foto barang secara keseluruhan',
      'icon': Icons.photo_camera,
      'illustration': 'overall',
    },
    {
      'title': 'Label Alamat',
      'description': 'Foto label alamat penerima',
      'icon': Icons.label,
      'illustration': 'label',
    },
    {
      'title': 'Nomor Resi',
      'description': 'Foto nomor resi pada paket',
      'icon': Icons.qr_code,
      'illustration': 'resi',
    },
    {
      'title': 'Kondisi Kemasan',
      'description': 'Foto kondisi fisik kemasan',
      'icon': Icons.inventory,
      'illustration': 'packaging',
    },
    {
      'title': 'Tanda Tangan',
      'description': 'Foto tanda tangan penerima',
      'icon': Icons.edit,
      'illustration': 'signature',
    },
    {
      'title': 'Identitas Penerima',
      'description': 'Foto KTP/SIM penerima',
      'icon': Icons.badge,
      'illustration': 'id',
    },
    {
      'title': 'Serah Terima',
      'description': 'Foto bersama dengan penerima',
      'icon': Icons.people,
      'illustration': 'handover',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Progress indicator dengan angka
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: List.generate(7, (index) {
                bool isCompleted = photoTaken[index];
                bool isCurrent = index == currentStep;

                return Expanded(
                  child: Container(
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color:
                          isCompleted
                              ? Colors.green
                              : isCurrent
                              ? const Color(0xFF4A90E2)
                              : Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child:
                          isCompleted
                              ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                              : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color:
                                      isCurrent
                                          ? Colors.white
                                          : Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Info singkat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Langkah ${currentStep + 1} dari 7',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton.icon(
                onPressed: _hasAnyPhoto() ? _showPreview : null,
                icon: Icon(
                  Icons.visibility,
                  size: 16,
                  color: _hasAnyPhoto() ? const Color(0xFF4A90E2) : Colors.grey,
                ),
                label: Text(
                  'Preview',
                  style: TextStyle(
                    color:
                        _hasAnyPhoto() ? const Color(0xFF4A90E2) : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Content utama tanpa scroll
          Expanded(
            child: Column(
              children: [
                // Status foto kompak
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        photoTaken[currentStep]
                            ? Colors.green[50]
                            : Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          photoTaken[currentStep]
                              ? Colors.green[200]!
                              : Colors.blue[200]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        photoTaken[currentStep]
                            ? Icons.check_circle
                            : Icons.camera_alt,
                        color:
                            photoTaken[currentStep]
                                ? Colors.green[700]
                                : Colors.blue[700],
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          photoTaken[currentStep]
                              ? 'Foto berhasil diambil!'
                              : 'Siap mengambil foto',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color:
                                photoTaken[currentStep]
                                    ? Colors.green[700]
                                    : Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Title dan description singkat
                Text(
                  photoSteps[currentStep]['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  photoSteps[currentStep]['description'],
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),

                // Preview foto jika sudah ada
                if (photoTaken[currentStep] && photoUrls[currentStep] != null)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[300]!, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Image.network(
                              photoUrls[currentStep]!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  // Panduan visual kompak
                  Expanded(
                    child: _buildCompactPhotoGuide(
                      photoSteps[currentStep]['illustration'],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Navigation buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildCompactPhotoGuide(String type) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4A90E2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildIllustration(type),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        // Main action button (Ambil Foto)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _takePhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  photoTaken[currentStep] ? 'Foto Ulang' : 'Ambil Foto',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Navigation buttons row
        Row(
          children: [
            // Previous button
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      currentStep--;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4A90E2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF4A90E2),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Sebelumnya',
                        style: TextStyle(
                          color: Color(0xFF4A90E2),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (currentStep > 0) const SizedBox(width: 10),

            // Next button - hanya muncul jika foto sudah diambil
            if (photoTaken[currentStep])
              Expanded(
                child: ElevatedButton(
                  onPressed: currentStep < 6 ? _goToNextStep : _showPreview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentStep < 6 ? 'Selanjutnya' : 'Selesai',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        currentStep < 6 ? Icons.arrow_forward_ios : Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),

            // Skip button - kompak
            if (!photoTaken[currentStep] && currentStep < 6)
              Expanded(
                child: TextButton(
                  onPressed: _showSkipDialog,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Lewati',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _goToNextStep() {
    if (currentStep < 6) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _showSkipDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange, size: 24),
                SizedBox(width: 8),
                Text('Lewati Foto?', style: TextStyle(fontSize: 16)),
              ],
            ),
            content: Text(
              'Yakin ingin melewati foto ${photoSteps[currentStep]['title']}?',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(fontSize: 14)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _goToNextStep();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Lewati',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
    );
  }

  // Illustration methods - simplified
  Widget _buildIllustration(String type) {
    switch (type) {
      case 'overall':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tv, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Foto Keseluruhan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'label':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.label, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Label Alamat',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'resi':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.qr_code, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Nomor Resi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'packaging':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Kondisi Kemasan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'signature':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Tanda Tangan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'id':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.badge, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Identitas KTP/SIM',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      case 'handover':
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, size: 50, color: Colors.grey[600]),
              const SizedBox(height: 8),
              Text(
                'Foto Bersama',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      default:
        return Center(
          child: Icon(Icons.camera_alt, size: 50, color: Colors.grey[400]),
        );
    }
  }

  bool _hasAnyPhoto() {
    return photoTaken.any((taken) => taken);
  }

  void _showPreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FotoPreviewScreen(
              resi: widget.resi,
              photoUrls: photoUrls,
              onRetakePhoto: (index) {
                setState(() {
                  currentStep = index;
                });
              },
              onComplete: widget.onComplete,
            ),
      ),
    );
  }

  void _takePhoto() {
    // Simulasi loading saat mengambil foto
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
                  'Mengambil foto...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
    );

    // Simulasi delay mengambil foto
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      setState(() {
        photoTaken[currentStep] = true;
        photoUrls[currentStep] =
            'https://picsum.photos/400/600?random=${currentStep + 1}';
      });
    });
  }
}

// Custom painter untuk border putus-putus
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF4A90E2)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 4.0;

    // Top border
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }

    // Right border
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    // Bottom border
    startX = size.width;
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    // Left border
    startY = size.height;
    while (startY > 0) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY - dashWidth), paint);
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter untuk tanda tangan
class SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.4,
      size.width * 0.3,
      size.width * 0.6,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.7,
      size.width * 0.9,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
