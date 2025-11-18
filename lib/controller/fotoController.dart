import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class FotoController extends ChangeNotifier {
  bool _isUploading = false;
  String _errorMessage = '';
  String _successMessage = '';

  bool get isUploading => _isUploading;
  String get errorMessage => _errorMessage;
  String get successMessage => _successMessage;

  static const String _baseUrl = 'https://monitoringweb.decoratics.id/api';

  /// Update order dengan data kurir sebelum upload foto
  Future<bool> updateOrder({
    required String awb,
    required int idKurir,
    required String tanggal,
  }) async {
    _isUploading = true;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();

    try {
      final url = '$_baseUrl/KURIR/update-order';

      print('[DEBUG] Updating order from: $url');
      print('[DEBUG] Payload - AWB: $awb, ID Kurir: $idKurir, Tanggal: $tanggal');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NagaCargoApp/1.0',
        },
        body: jsonEncode({
          'AWB': awb,
          'id_kurir': idKurir,
          'tanggal': tanggal,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      print('[DEBUG] Update order response status: ${response.statusCode}');
      print('[DEBUG] Update order response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _successMessage = data['message'] ?? 'Order berhasil diupdate';
        print('[DEBUG] ✓ Order updated successfully');
        _isUploading = false;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Gagal mengupdate order';
        print('[DEBUG] ✗ Failed to update order: ${response.statusCode}');
        _isUploading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      print('[DEBUG] Error updating order: $e');
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  /// Upload foto dokumentasi (7 foto sekaligus)
  Future<bool> uploadFoto({
    required String awb,
    required List<File?> photoFiles,
    required List<String> photoDescriptions,
  }) async {
    _isUploading = true;
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();

    try {
      // Validasi semua foto sudah terisi
      if (photoFiles.any((file) => file == null)) {
        _errorMessage = 'Semua foto harus terisi sebelum upload';
        _isUploading = false;
        notifyListeners();
        return false;
      }

      final url = '$_baseUrl/KURIR/upload-foto';

      print('[DEBUG] Uploading photos from: $url');
      print('[DEBUG] AWB: $awb, Total photos: ${photoFiles.length}');

      // Gunakan MultipartRequest untuk upload multiple files
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Tambah field AWB
      request.fields['AWB'] = awb;

      // Tambah setiap foto
      for (int i = 0; i < photoFiles.length; i++) {
        final file = photoFiles[i];
        if (file != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'fotos[$i]', // Laravel akan menerima sebagai array fotos
              file.path,
              filename: '${awb}_${i + 1}.jpg',
            ),
          );

          // Tambah keterangan untuk setiap foto
          request.fields['keterangan[$i]'] = photoDescriptions[i];
          print('[DEBUG] Photo $i added: ${photoDescriptions[i]}');
        }
      }

      request.headers.addAll({
        'User-Agent': 'NagaCargoApp/1.0',
      });

      // Send request
      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('[DEBUG] Upload response status: ${response.statusCode}');
      print('[DEBUG] Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _successMessage = data['message'] ?? 'Foto berhasil diupload';
        print(
          '[DEBUG] ✓ Photos uploaded successfully - Total: ${data['total_fotos']}',
        );
        _isUploading = false;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Gagal upload foto';
        print('[DEBUG] ✗ Failed to upload photos: ${response.statusCode}');
        _isUploading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      print('[DEBUG] Error uploading photos: $e');
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = '';
    _successMessage = '';
    notifyListeners();
  }
}