import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://monitoringweb.decoratics.id/api';

  /// Login untuk KURIR
  Future<Map<String, dynamic>> loginKurir({
    required String username,
    required String password,
  }) async {
    try {
      const String endpoint = '$_baseUrl/KURIR/login';
      
      print('[DEBUG] Kurir login attempt - Username: $username');
      
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NagaCargoApp/1.0',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('[DEBUG] Kurir login response status: ${response.statusCode}');
      print('[DEBUG] Kurir login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['message'] != null && data['message'].toString().toLowerCase().contains('berhasil')) {
          final user = data['user'] ?? {};
          final namaDaerah = data['nama_daerah'] ?? user['nama_daerah'] ?? 'Unknown';
          final idDaerah = user['id_daerah']; // Ambil id_daerah dari user object
          
          print('[DEBUG] ✓ Kurir login API response success');
          print('[DEBUG] User: ${user['nama']}, ID Daerah: $idDaerah, Daerah: $namaDaerah');
          
          return {
            'success': true,
            'message': 'Login berhasil',
            'user': user,
            'nama_daerah': namaDaerah,
            'id_daerah': idDaerah,
          };
        } else {
          final errorMsg = data['message'] ?? 'Username atau password salah';
          return {
            'success': false,
            'message': errorMsg,
          };
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('[DEBUG] ✗ Unauthorized - Username atau password salah');
        return {
          'success': false,
          'message': 'Username atau password salah',
        };
      } else {
        print('[DEBUG] ✗ Server error: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('[DEBUG] ✗ Kurir login error: $e');
      return {
        'success': false,
        'message': 'Error koneksi: $e',
      };
    }
  }
}