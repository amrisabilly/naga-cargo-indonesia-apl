import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  String? _namaDaerah;
  bool _isLoading = false;
  List<dynamic> _riwayatOrder = [];
  bool _isLoadingRiwayat = false;

  Map<String, dynamic>? get userData => _userData;
  String? get namaDaerah => _namaDaerah;
  bool get isLoading => _isLoading;
  List<dynamic> get riwayatOrder => _riwayatOrder;
  bool get isLoadingRiwayat => _isLoadingRiwayat;

  static const String _userDataKey = 'kurir_user_data';
  static const String _namaDaerahKey = 'kurir_nama_daerah';
  static const String _baseUrl = 'https://monitoringweb.decoratics.id/api';

  /// Load data dari SharedPreferences
  Future<void> loadProfileData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final userDataJson = prefs.getString(_userDataKey);
      final namaDaerah = prefs.getString(_namaDaerahKey);

      if (userDataJson != null) {
        _userData = jsonDecode(userDataJson);
        _namaDaerah = namaDaerah;
        print('[DEBUG] Profile data loaded: ${_userData?['nama']}');
      } else {
        print('[DEBUG] No profile data found in SharedPreferences');
      }
    } catch (e) {
      print('[DEBUG] Error loading profile data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load riwayat order dari API
  Future<void> loadRiwayatOrder() async {
    _isLoadingRiwayat = true;
    notifyListeners();

    try {
      if (_userData == null || _userData?['id_user'] == null) {
        print('[DEBUG] User data not available');
        _isLoadingRiwayat = false;
        notifyListeners();
        return;
      }

      final idKurir = _userData?['id_user'];
      final url = '$_baseUrl/KURIR/riwayat-order?id_kurir=$idKurir';

      print('[DEBUG] Loading riwayat order from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NagaCargoApp/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('[DEBUG] Riwayat order response status: ${response.statusCode}');
      print('[DEBUG] Riwayat order response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _riwayatOrder = data['orders'] ?? [];
        print('[DEBUG] ✓ Riwayat order loaded: ${_riwayatOrder.length} orders');
      } else {
        print('[DEBUG] ✗ Failed to load riwayat order: ${response.statusCode}');
        _riwayatOrder = [];
      }
    } catch (e) {
      print('[DEBUG] Error loading riwayat order: $e');
      _riwayatOrder = [];
    }

    _isLoadingRiwayat = false;
    notifyListeners();
  }

  /// Get user properties dengan nilai default
  String get namaKurir => _userData?['nama'] ?? 'Nama tidak tersedia';
  String get username => _userData?['username'] ?? 'Username tidak tersedia';
  String get noHp => _userData?['no_hp'] ?? 'Nomor HP tidak tersedia';
  String get role => _userData?['role'] ?? 'Role tidak tersedia';
  String get status => _userData?['status'] ?? 'Status tidak tersedia';
  int? get idUser => _userData?['id_user'];
  String get daerah => _namaDaerah ?? 'Daerah tidak tersedia';
  int get totalRiwayat => _riwayatOrder.length;

  /// Format tanggal
  String get createdAt {
    if (_userData?['created_at'] == null) return 'Tidak tersedia';
    try {
      final dateTime = DateTime.parse(_userData!['created_at']);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return _userData?['created_at'] ?? 'Tidak tersedia';
    }
  }

  /// Format tanggal dari string
  String formatTanggal(String? tanggal) {
    if (tanggal == null) return 'Tidak ada tanggal';
    try {
      final dateTime = DateTime.parse(tanggal);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return tanggal;
    }
  }

  /// Get status color
  Color getStatusColor() {
    final status = _userData?['status']?.toString().toLowerCase() ?? '';
    if (status.contains('aktif')) {
      return Colors.green;
    } else if (status.contains('nonaktif')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  /// Get status icon
  IconData getStatusIcon() {
    final status = _userData?['status']?.toString().toLowerCase() ?? '';
    if (status.contains('aktif')) {
      return Icons.check_circle;
    } else if (status.contains('nonaktif')) {
      return Icons.cancel;
    }
    return Icons.help;
  }

  /// Get order status color
  Color getOrderStatusColor(String? orderStatus) {
    final status = orderStatus?.toString().toLowerCase() ?? '';
    if (status.contains('terkirim')) {
      return Colors.green;
    } else if (status.contains('proses')) {
      return Colors.orange;
    } else if (status.contains('gagal')) {
      return Colors.red;
    }
    return Colors.grey;
  }

  /// Get order status icon
  IconData getOrderStatusIcon(String? orderStatus) {
    final status = orderStatus?.toString().toLowerCase() ?? '';
    if (status.contains('terkirim')) {
      return Icons.check_circle;
    } else if (status.contains('proses')) {
      return Icons.schedule;
    } else if (status.contains('gagal')) {
      return Icons.cancel;
    }
    return Icons.help;
  }
}