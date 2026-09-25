import 'package:flutter/material.dart';
import '../layanan/layanan_konsultasi.dart';
import '../model/model_konsultasi.dart';

class PenyediaKonsultasi with ChangeNotifier {
  final LayananKonsultasi _layanan = LayananKonsultasi();
  List<ModelKonsultasi> _daftarKonsultasi = [];
  bool _memuat = false;
  String? _pesanError;

  List<ModelKonsultasi> get daftarKonsultasi => _daftarKonsultasi;
  bool get memuat => _memuat;
  String? get pesanError => _pesanError;

  Future<void> ambilKonsultasi(String token) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      _daftarKonsultasi = await _layanan.ambilKonsultasi(token);
    } catch (e) {
      _pesanError = e.toString();
    } finally {
      _memuat = false;
      notifyListeners();
    }
  }

  Future<bool> tambahKonsultasi(String token, String komoditas, String judul, String gejala, String urgensi, String? pathFoto) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final konsultasiBaru = await _layanan.tambahKonsultasi(token, komoditas, judul, gejala, urgensi, pathFoto);
      _daftarKonsultasi.insert(0, konsultasiBaru);
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

  Future<void> perbaruiDetailKonsultasi(String token, int id) async {
    try {
      final detail = await _layanan.detailKonsultasi(token, id);
      final index = _daftarKonsultasi.indexWhere((k) => k.id == id);
      if (index != -1) {
        _daftarKonsultasi[index] = detail;
        notifyListeners();
      }
    } catch (e) {
      // Abaikan error polling
    }
  }

  Future<bool> kirimPesan(String token, int konsultasiId, String? pesan, {String? pathFoto}) async {
    try {
      final pesanBaru = await _layanan.kirimPesan(token, konsultasiId, pesan, pathFoto: pathFoto);
      final index = _daftarKonsultasi.indexWhere((k) => k.id == konsultasiId);
      if (index != -1) {
        _daftarKonsultasi[index].pesan.add(pesanBaru);
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> tandaiSelesai(String token, int konsultasiId) async {
    try {
      final updated = await _layanan.tandaiSelesai(token, konsultasiId);
      final index = _daftarKonsultasi.indexWhere((k) => k.id == konsultasiId);
      if (index != -1) {
        _daftarKonsultasi[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
