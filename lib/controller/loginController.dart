import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import '../services/location_service.dart';

class LoginController extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _userData;
  String? _namaDaerah;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  String? get namaDaerah => _namaDaerah;
  bool get isLoggedIn => _isLoggedIn;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  final LocationService _locationService = LocationService();

  static const String _userDataKey = 'kurir_user_data';
  static const String _namaDaerahKey = 'kurir_nama_daerah';
  static const String _isLoggedInKey = 'kurir_is_logged_in';

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Simpan user data ke SharedPreferences setelah login sukses
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_userData != null) {
        // Simpan user data sebagai JSON string
        await prefs.setString(_userDataKey, jsonEncode(_userData));
        print('[DEBUG] Kurir user data disimpan ke SharedPreferences');
      }
      
      if (_namaDaerah != null) {
        await prefs.setString(_namaDaerahKey, _namaDaerah!);
        print('[DEBUG] Kurir nama daerah disimpan ke SharedPreferences');
      }
      
      await prefs.setBool(_isLoggedInKey, true);
      print('[DEBUG] Kurir login status: true');
    } catch (e) {
      print('[DEBUG] ERROR menyimpan kurir user data: $e');
    }
  }

  /// Ambil user data dari SharedPreferences saat app startup
  Future<void> loadSavedUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final userDataJson = prefs.getString(_userDataKey);
      final namaDaerah = prefs.getString(_namaDaerahKey);
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (userDataJson != null && isLoggedIn) {
        _userData = jsonDecode(userDataJson);
        _namaDaerah = namaDaerah;
        _isLoggedIn = true;
        print('[DEBUG] Kurir user data dimuat dari SharedPreferences: ${_userData?['nama']}');
        notifyListeners();
      } else {
        _isLoggedIn = false;
        print('[DEBUG] Tidak ada data login sebelumnya');
        notifyListeners();
      }
    } catch (e) {
      print('[DEBUG] ERROR memuat kurir user data: $e');
      _isLoggedIn = false;
      notifyListeners();
    }
  }

  /// Fungsi login utama untuk KURIR (dengan SharedPreferences)
  Future<void> login(BuildContext context) async {
    print('[DEBUG] === KURIR LOGIN DIMULAI ===');
    _errorMessage = '';

    if (usernameController.text.trim().isEmpty) {
      _errorMessage = 'Username tidak boleh kosong';
      notifyListeners();
      return;
    }

    if (passwordController.text.trim().isEmpty) {
      _errorMessage = 'Password tidak boleh kosong';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    print('[DEBUG] Loading: true');

    try {
      // 1. Validasi kredensial kurir
      print('[DEBUG] Step 1: Calling AuthService.loginKurir()');
      
      final loginResult = await _authService.loginKurir(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('[DEBUG] LoginResult: $loginResult');

      if (!loginResult['success']) {
        _errorMessage = loginResult['message'];
        _isLoading = false;
        print('[DEBUG] ✗ Kurir login failed: $_errorMessage');
        notifyListeners();
        return;
      }

      print('[DEBUG] ✓ Kredensial kurir valid');

      _userData = loginResult['user'];
      _namaDaerah = loginResult['nama_daerah'];
      
      print('[DEBUG] Kurir user data: $_userData');
      print('[DEBUG] Kurir nama daerah: $_namaDaerah');
      notifyListeners();

      // 2. Dapatkan lokasi
      print('[DEBUG] Step 2: Getting current location');
      
      final locationResult = await _locationService.getCurrentLocation();
      print('[DEBUG] Location result: $locationResult');
      
      if (!locationResult['success']) {
        _errorMessage = locationResult['message'];
        _isLoading = false;
        _userData = null;
        _namaDaerah = null;
        print('[DEBUG] ✗ Location error: $_errorMessage');
        notifyListeners();
        return;
      }

      Position position = locationResult['position'];
      print('[DEBUG] ✓ Location: ${position.latitude}, ${position.longitude}');

      // 3. Dapatkan nama daerah dari koordinat GPS
      print('[DEBUG] Step 3: Getting area from coordinates');
      
      final areaResult = await _locationService.getAreaFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      print('[DEBUG] Area result: $areaResult');

      if (!areaResult['success']) {
        _errorMessage = areaResult['message'];
        _isLoading = false;
        _userData = null;
        _namaDaerah = null;
        print('[DEBUG] ✗ Area error: $_errorMessage');
        notifyListeners();
        return;
      }

      String lokasiDaerah = areaResult['area_name'];
      print('[DEBUG] ✓ Area: $lokasiDaerah');

      // 4. Bandingkan lokasi GPS dengan daerah kerja kurir
      print('[DEBUG] Step 4: Comparing location');
      print('[DEBUG] Lokasi GPS: $lokasiDaerah vs Daerah kerja kurir: $_namaDaerah');
      print('[DEBUG] Lokasi GPS (lowercase): ${lokasiDaerah.toLowerCase()}');
      print('[DEBUG] Daerah kerja (lowercase): ${_namaDaerah?.toLowerCase()}');
      
      // Normalisasi nama daerah (hapus extra spaces)
      String normalizedLokasiDaerah = lokasiDaerah.toLowerCase().trim();
      String normalizedNamaDaerah = _namaDaerah?.toLowerCase().trim() ?? '';
      
      print('[DEBUG] Normalized Lokasi GPS: "$normalizedLokasiDaerah"');
      print('[DEBUG] Normalized Daerah kerja: "$normalizedNamaDaerah"');
      print('[DEBUG] Are they equal? ${normalizedLokasiDaerah == normalizedNamaDaerah}');
      
      if (normalizedLokasiDaerah == normalizedNamaDaerah) {
        
        print('[DEBUG] ✓ Lokasi sesuai!');
        
        // SIMPAN DATA KE SHAREDPREFERENCES
        print('[DEBUG] Step 5: Saving to SharedPreferences');
        await _saveUserData();
        
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        print('[DEBUG] ✓✓✓ KURIR LOGIN SUKSES!');
        print('[DEBUG] Kurir: ${_userData?['nama']}, Daerah: $_namaDaerah');
        
        // PENTING: Wait sebentar agar notifyListeners propagate
        await Future.delayed(const Duration(milliseconds: 100));
        
        // NAVIGASI ke beranda kurir
        if (context.mounted) {
          print('[DEBUG] Calling context.go(/beranda_kurir)');
          context.go('/beranda_kurir');
        } else {
          print('[DEBUG] ✗ Context not mounted!');
        }
      } else {
        print('[DEBUG] ✗ Lokasi TIDAK SESUAI!');
        print('[DEBUG] Expected: "$normalizedNamaDaerah"');
        print('[DEBUG] Got: "$normalizedLokasiDaerah"');
        
        _errorMessage = 
            'Akses ditolak!\n\nLokasi Anda: $lokasiDaerah\nDaerah kerja: $_namaDaerah\n\nAnda hanya bisa login dari wilayah kerja yang sudah ditentukan.';
        _isLoading = false;
        _userData = null;
        _namaDaerah = null;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Terjadi kesalahan: $e';
      _userData = null;
      _namaDaerah = null;
      _isLoggedIn = false;
      notifyListeners();
      print('[DEBUG] ✗✗✗ ERROR Kurir Login: $e');
    }
  }

  /// Logout dan hapus semua data kurir
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_namaDaerahKey);
      await prefs.remove(_isLoggedInKey);
      print('[DEBUG] Kurir SharedPreferences cleared');
      
      _userData = null;
      _namaDaerah = null;
      _isLoggedIn = false;
      usernameController.clear();
      passwordController.clear();
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      print('[DEBUG] ERROR kurir logout: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
