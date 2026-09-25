import 'package:flutter/material.dart';
import '../layanan/layanan_pengaduan.dart';
import '../model/model_pengaduan.dart';

class PenyediaPengaduan with ChangeNotifier {
  final LayananPengaduan _layanan = LayananPengaduan();
  List<ModelPengaduan> _daftarPengaduan = [];
  bool _memuat = false;
  String? _pesanError;

  List<ModelPengaduan> get daftarPengaduan => _daftarPengaduan;
  bool get memuat => _memuat;
  String? get pesanError => _pesanError;

  Future<void> ambilPengaduan(String token) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      _daftarPengaduan = await _layanan.ambilPengaduan(token);
    } catch (e) {
      _pesanError = e.toString();
    } finally {
      _memuat = false;
      notifyListeners();
    }
  }

  Future<bool> tambahPengaduan(String token, String kategori, String lokasi, String deskripsi, String? pathFoto) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final pengaduanBaru = await _layanan.tambahPengaduan(token, kategori, lokasi, deskripsi, pathFoto);
      _daftarPengaduan.insert(0, pengaduanBaru);
      _memuat = false;
      notifyListeners();
      return true;
    } catch (e) {
      _pesanError = e.toString();
      _memuat = false;
      notifyListeners();
      return false;
    }
  }
}
