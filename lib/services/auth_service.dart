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
        
        // PENTING: Response format dari API adalah:
        // {"message":"Login berhasil","user":{...},"nama_daerah":"Jakarta"}
        // Jadi cek field 'message' bukan 'success'
        
        if (data['message'] != null && data['message'].toString().toLowerCase().contains('berhasil')) {
          final user = data['user'] ?? {};
          final namaDaerah = data['nama_daerah'] ?? user['nama_daerah'] ?? 'Unknown';
          
          print('[DEBUG] ✓ Kurir login API response success');
          print('[DEBUG] User: ${user['nama']}, Daerah: $namaDaerah');
          
          return {
            'success': true,
            'message': 'Login berhasil',
            'user': user,
            'nama_daerah': namaDaerah,
          };
        } else {
          // Jika message tidak berhasil
          final errorMsg = data['message'] ?? 'Username atau password salah';
          print('[DEBUG] ✗ API returned non-success message: $errorMsg');
          
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