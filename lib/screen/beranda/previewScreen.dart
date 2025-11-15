import 'package:flutter/material.dart';

class FotoPreviewScreen extends StatefulWidget {
  final String resi;
  final List<String?> photoUrls;
  final Function(int) onRetakePhoto;
  final VoidCallback onComplete;

  const FotoPreviewScreen({
    super.key,
    required this.resi,
    required this.photoUrls,
    required this.onRetakePhoto,
    required this.onComplete,
  });

  @override
  State<FotoPreviewScreen> createState() => _FotoPreviewScreenState();
}

class _FotoPreviewScreenState extends State<FotoPreviewScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> photoSteps = [
    {
      'title': 'Foto 1: Tampak Keseluruhan',
      'description':
          'Foto barang dari jarak yang menampilkan keseluruhan paket',
    },
    {
      'title': 'Foto 2: Label Alamat',
      'description': 'Foto label alamat penerima dan pengirim',
    },
    {
      'title': 'Foto 3: Nomor Resi',
      'description': 'Foto close-up nomor resi pada paket',
    },
    {
      'title': 'Foto 4: Kondisi Kemasan',
      'description': 'Foto kondisi fisik kemasan paket',
    },
    {
      'title': 'Foto 5: Tanda Tangan Penerima',
      'description': 'Foto tanda tangan penerima',
    },
    {
      'title': 'Foto 6: Identitas Penerima',
      'description': 'Foto identitas (KTP/SIM) penerima barang',
    },
    {
      'title': 'Foto 7: Dokumentasi Serah Terima',
      'description': 'Foto bersama dengan penerima dan paket',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: screenHeight * 0.25,
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
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
                                'Preview Foto Dokumentasi',
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
                        IconButton(
                          // HAPUS: onPressed: _showPhotoGrid,
                          // HAPUS: icon: const Icon(
                          //   Icons.grid_view,
                          //   color: Colors.white,
                          //   size: 28,
                          // ),
                          onPressed: null,
                          icon: const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Indicator foto
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (index) {
                        return Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color:
                                index == currentIndex
                                    ? Colors.white
                                    : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
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
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Photo viewer
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return _buildPhotoCard(index);
                      },
                    ),
                  ),

                  // Navigation and action buttons
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Photo counter
                        Text(
                          '${currentIndex + 1} dari 7',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  widget.onRetakePhoto(currentIndex);
                                  Navigator.of(context).pop();
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF4A90E2),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFF4A90E2),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.photoUrls[currentIndex] != null
                                          ? 'Foto Ulang'
                                          : 'Ambil Foto',
                                      style: const TextStyle(
                                        color: Color(0xFF4A90E2),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    _isAllPhotosComplete()
                                        ? () {
                                          widget.onComplete();
                                          Navigator.of(context).pop();
                                        }
                                        : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A90E2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                child: const Text(
                                  'Selesai',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(int index) {
    final photoUrl = widget.photoUrls[index];
    final step = photoSteps[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Title and description
          Text(
            step['title'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            step['description'],
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Photo container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      photoUrl != null ? Colors.green[300]! : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child:
                  photoUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderPhoto(index, isError: true);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      )
                      : _buildPlaceholderPhoto(index),
            ),
          ),

          const SizedBox(height: 15),

          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: photoUrl != null ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    photoUrl != null ? Colors.green[200]! : Colors.orange[200]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  photoUrl != null ? Icons.check_circle : Icons.camera_alt,
                  size: 16,
                  color:
                      photoUrl != null ? Colors.green[700] : Colors.orange[700],
                ),
                const SizedBox(width: 8),
                Text(
                  photoUrl != null ? 'Foto Tersimpan' : 'Belum Difoto',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        photoUrl != null
                            ? Colors.green[700]
                            : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPhoto(int index, {bool isError = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.camera_alt,
            size: 60,
            color: isError ? Colors.red[300] : Colors.grey[400],
          ),
          const SizedBox(height: 15),
          Text(
            isError ? 'Gagal memuat foto' : 'Belum ada foto',
            style: TextStyle(
              fontSize: 16,
              color: isError ? Colors.red[600] : Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isError) ...[
            const SizedBox(height: 8),
            Text(
              'Tap "Foto Ulang" untuk mengambil foto baru',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  bool _isAllPhotosComplete() {
    return widget.photoUrls.every((url) => url != null);
  }
}
