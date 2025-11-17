import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org/reverse';

  /// Dapatkan lokasi saat ini
  Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {
          'success': false,
          'message': 'Layanan lokasi tidak aktif. Silakan aktifkan GPS.',
        };
      }

      // Cek permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {
            'success': false,
            'message': 'Izin lokasi ditolak.',
          };
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return {
          'success': false,
          'message': 'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan.',
        };
      }

      // Dapatkan posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('[DEBUG] ✓ Location obtained: ${position.latitude}, ${position.longitude}');

      return {
        'success': true,
        'message': 'Lokasi berhasil didapatkan',
        'position': position,
      };
    } catch (e) {
      print('[DEBUG] ✗ Location error: $e');
      return {
        'success': false,
        'message': 'Gagal mendapatkan lokasi: $e',
      };
    }
  }

  /// Dapatkan nama daerah (county) dari koordinat GPS menggunakan Nominatim API
  Future<Map<String, dynamic>> getAreaFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final url = '$_nominatimUrl?format=json&lat=$latitude&lon=$longitude&zoom=10&addressdetails=1';

      print('[DEBUG] Calling Nominatim API: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'NagaCargoApp/1.0',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Nominatim request timeout');
        },
      );

      print('[DEBUG] Nominatim response status: ${response.statusCode}');
      print('[DEBUG] Nominatim response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ekstraksi county dari response
        String? county = data['address']?['county'];

        if (county != null && county.isNotEmpty) {
          print('[DEBUG] ✓ County found: $county');
          return {
            'success': true,
            'message': 'Area berhasil didapatkan',
            'area_name': county,
            'full_response': data,
          };
        } else {
          print('[DEBUG] ✗ County not found in response');
          return {
            'success': false,
            'message': 'Tidak dapat menentukan wilayah Anda',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Gagal mendapatkan informasi lokasi dari server (${response.statusCode})',
        };
      }
    } catch (e) {
      print('[DEBUG] ✗ Error mendapatkan area: $e');
      return {
        'success': false,
        'message': 'Error koneksi: $e',
      };
    }
  }

  /// Bandingkan dua nama daerah (case insensitive)
  bool compareArea(String area1, String area2) {
    return area1.toLowerCase().trim() == area2.toLowerCase().trim();
  }
}