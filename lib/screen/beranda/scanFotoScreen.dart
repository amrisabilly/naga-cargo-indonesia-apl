import 'package:flutter/material.dart';
import 'package:cargo_app/screen/beranda/previewFotoScreen.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controller/fotoController.dart';
import '../../controller/loginController.dart';
import 'package:go_router/go_router.dart';

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
  List<File?> photoFiles = List.filled(7, null);

  final ImagePicker _picker = ImagePicker();

  // Deskripsi untuk setiap foto
  final List<String> photoDescriptions = [
    'Tampak Keseluruhan',
    'Label Alamat',
    'Nomor Resi',
    'Kondisi Kemasan',
    'Tanda Tangan Penerima',
    'Identitas Penerima',
    'Dokumentasi Serah Terima',
  ];

  final List<Map<String, dynamic>> photoSteps = [
    {
      'title': 'Tampak Keseluruhan',
      'description': 'Pastikan agar pengambilan foto mode landscape (miring).',
      'image': 'assets/images/keseluruhan.jpg',
    },
    {
      'title': 'Tampak Barang',
      'description':
          'Pastikan label alamat penerima terlihat jelas seperti contoh di bawah.',
      'image': 'assets/images/barang.jpg',
    },
    {
      'title': 'Nomor Resi',
      'description':
          'Pastikan nomor resi pada paket terlihat jelas seperti contoh di bawah.',
      'image': 'assets/images/resi.jpg',
    },
    {
      'title': 'Tampak Kanan',
      'description':
          'Pastikan kondisi fisik kemasan terlihat seperti contoh di bawah.',
      'image': 'assets/images/kanan.jpg',
    },
    {
      'title': 'Tampak Kiri',
      'description':
          'Pastikan tanda tangan penerima terlihat jelas seperti contoh di bawah.',
      'image': 'assets/images/kiri.jpg',
    },
    {
      'title': 'Identitas Penerima',
      'description':
          'Pastikan KTP/SIM penerima terlihat jelas seperti contoh di bawah.',
      'image': 'assets/images/barang.jpg',
    },
    {
      'title': 'Serah Terima',
      'description':
          'Pastikan foto bersama penerima dan paket seperti contoh di bawah.',
      'image': 'assets/images/barang.jpg',
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
                if (photoTaken[currentStep] && photoFiles[currentStep] != null)
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
                            Center(
                              child: Image.file(
                                photoFiles[currentStep]!,
                                fit: BoxFit.contain,
                                height: 220,
                              ),
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
                      photoSteps[currentStep]['image'],
                      photoSteps[currentStep]['title'],
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

  Widget _buildCompactPhotoGuide(String imagePath, String title) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, fit: BoxFit.contain, height: 180),
            const SizedBox(height: 10),
            Text(
              'Contoh: $title',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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
                  onPressed: currentStep < 6 ? _goToNextStep : _submitPhotos,
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
                        currentStep < 6 ? 'Selanjutnya' : 'Upload Foto',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        currentStep < 6
                            ? Icons.arrow_forward_ios
                            : Icons.cloud_upload,
                        color: Colors.white,
                        size: 14,
                      ),
                    ],
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

  bool _hasAnyPhoto() {
    return photoTaken.any((taken) => taken);
  }

  void _showPreview() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FotoPreviewScreen(
              resi: widget.resi,
              photoFiles: photoFiles,
              onRetakePhoto: (index) {
                setState(() {
                  currentStep = index;
                });
              },
              onComplete: _submitPhotos,
            ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() {
        photoTaken[currentStep] = true;
        photoFiles[currentStep] = File(pickedFile.path);
      });
    }
  }

  /// Submit foto dan update order ke API
  Future<void> _submitPhotos() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('Mengunggah foto dokumentasi...'),
                ],
              ),
            ),
          ),
    );

    try {
      final fotoController = context.read<FotoController>();
      final loginController = context.read<LoginController>();

      // Step 1: Update order dulu
      print('[DEBUG] Step 1: Updating order...');
      final updateSuccess = await fotoController.updateOrder(
        awb: widget.resi,
        idKurir: loginController.userData?['id_user'] ?? 0,
        tanggal: DateTime.now().toString().split(' ')[0],
      );

      if (!updateSuccess) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          _showErrorDialog(fotoController.errorMessage);
        }
        return;
      }

      // Step 2: Upload foto
      print('[DEBUG] Step 2: Uploading photos...');
      final uploadSuccess = await fotoController.uploadFoto(
        awb: widget.resi,
        photoFiles: photoFiles,
        photoDescriptions: photoDescriptions,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        if (uploadSuccess) {
          _showSuccessDialog(fotoController.successMessage);
        } else {
          _showErrorDialog(fotoController.errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        _showErrorDialog('Error: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Sukses'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              print('[DEBUG] Success dialog OK clicked');
              
              // Close dialog saja
              Navigator.of(dialogContext).pop();
              
              // Delay untuk ensure dialog sudah fully closed
              Future.delayed(const Duration(milliseconds: 300), () {
                if (mounted) {
                  print('[DEBUG] Navigating to beranda');
                  // Gunakan GoRouter untuk navigate, jangan Navigator.pop()
                  context.go('/beranda_kurir');
                }
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
