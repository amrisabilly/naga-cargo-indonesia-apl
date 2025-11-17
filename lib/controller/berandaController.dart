import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BerandaController extends ChangeNotifier {
  List<Map<String, dynamic>> _allOrders = []; // Semua data AWB daerah
  List<Map<String, dynamic>> _filteredOrders = []; // Data yang di-filter saat user mengetik
  bool _isLoadingOrders = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get allOrders => _allOrders;
  List<Map<String, dynamic>> get filteredOrders => _filteredOrders;
  bool get isLoadingOrders => _isLoadingOrders;
  String get errorMessage => _errorMessage;

  static const String _baseUrl = 'https://monitoringweb.decoratics.id/api';

  /// Load semua order berdasarkan daerah kurir saat buka Beranda
  Future<void> loadOrderByDaerah({
    required int idKurir,
  }) async {
    _isLoadingOrders = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = '$_baseUrl/KURIR/order-by-daerah?id_kurir=$idKurir';
      
      print('[DEBUG] Loading all orders from: $url');

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

      print('[DEBUG] Order by daerah response status: ${response.statusCode}');
      print('[DEBUG] Order by daerah response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final orders = data['orders'] as List? ?? [];
        
        _allOrders = orders.map<Map<String, dynamic>>((order) {
          return {
            'resi': order['AWB'] ?? 'N/A',
            'alamat': order['tujuan'] ?? 'Alamat tidak tersedia',
            'penerima': order['penerima'] ?? 'Penerima tidak tersedia',
            'status': order['status'] ?? 'Proses',
            'full_data': order,
          };
        }).toList();
        
        print('[DEBUG] ✓ All orders loaded: ${_allOrders.length} orders');
      } else if (response.statusCode == 404) {
        _errorMessage = 'Kurir tidak ditemukan';
        _allOrders = [];
        print('[DEBUG] ✗ Kurir not found: ${response.statusCode}');
      } else {
        _errorMessage = 'Gagal memuat data order';
        _allOrders = [];
        print('[DEBUG] ✗ Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      _allOrders = [];
      print('[DEBUG] Error loading orders: $e');
    }

    _isLoadingOrders = false;
    notifyListeners();
  }

  /// Filter order berdasarkan input user (AWB atau alamat)
  void filterOrders(String query) {
    if (query.isEmpty) {
      _filteredOrders = [];
      notifyListeners();
      return;
    }

    final lowerQuery = query.toLowerCase();
    
    _filteredOrders = _allOrders.where((order) {
      final resi = order['resi'].toString().toLowerCase();
      final alamat = order['alamat'].toString().toLowerCase();
      
      return resi.contains(lowerQuery) || alamat.contains(lowerQuery);
    }).toList();

    print('[DEBUG] Filtered orders: ${_filteredOrders.length} results');
    notifyListeners();
  }

  /// Clear filter
  void clearFilter() {
    _filteredOrders = [];
    _errorMessage = '';
    notifyListeners();
  }
}