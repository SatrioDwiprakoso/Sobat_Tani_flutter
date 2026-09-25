import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../konfigurasi/konstanta_api.dart';
import '../model/model_artikel.dart';

class PenyediaArtikel with ChangeNotifier {
  List<ModelArtikel> _daftarArtikel = [];
  bool _memuat = false;
  String? _pesanError;

  List<ModelArtikel> get daftarArtikel => _daftarArtikel;
  bool get memuat => _memuat;
  String? get pesanError => _pesanError;

  Future<void> ambilArtikel() async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(KonstantaApi.artikel));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _daftarArtikel = (data['data'] as List)
              .map((item) => ModelArtikel.fromJson(item))
              .toList();
        } else {
          _pesanError = 'Gagal memuat artikel.';
        }
      } else {
        _pesanError = 'Gagal terhubung ke server.';
      }
    } catch (e) {
      _pesanError = 'Terjadi kesalahan jaringan.';
    }

    _memuat = false;
    notifyListeners();
  }
}
