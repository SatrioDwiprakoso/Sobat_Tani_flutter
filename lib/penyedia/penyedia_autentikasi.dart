import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../layanan/layanan_autentikasi.dart';
import '../model/model_pengguna.dart';

class PenyediaAutentikasi with ChangeNotifier {
  final LayananAutentikasi _layanan = LayananAutentikasi();
  ModelPengguna? _pengguna;
  String? _token;
  bool _memuat = false;
  String? _pesanError;

  ModelPengguna? get pengguna => _pengguna;
  String? get token => _token;
  bool get memuat => _memuat;
  String? get pesanError => _pesanError;
  bool get sudahMasuk => _token != null;

  void perbaruiProfil(String nama, String email, String nomorTelepon) {
    if (_pengguna != null) {
      _pengguna = ModelPengguna(
        id: _pengguna!.id,
        namaLengkap: nama,
        email: email,
        nomorTelepon: nomorTelepon,
        peran: _pengguna!.peran,
      );
      notifyListeners();
    }
  }

  Future<void> periksaStatusMasuk() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token_akses');
    // Idealnya di sini ada pemanggilan endpoint profil untuk mendapatkan data pengguna
    notifyListeners();
  }

  Future<bool> masuk(String email, String password) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final respon = await _layanan.masuk(email, password);
      _token = respon['data']['akses_token'];
      _pengguna = ModelPengguna.fromJson(respon['data']['pengguna']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token_akses', _token!);
      
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

  Future<bool> daftar(String nama, String email, String password, String telepon) async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final respon = await _layanan.daftar(nama, email, password, telepon);
      _token = respon['data']['akses_token'];
      _pengguna = ModelPengguna.fromJson(respon['data']['pengguna']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token_akses', _token!);
      
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


  Future<bool> updateProfil(String namaLengkap, String nomorTelepon, {String? pathFoto}) async {
    if (_token == null) return false;
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      final penggunaBaru = await _layanan.updateProfil(_token!, namaLengkap: namaLengkap, nomorTelepon: nomorTelepon, pathFoto: pathFoto);
      _pengguna = penggunaBaru;
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

  Future<void> keluar() async {
    if (_token != null) {
      try {
        await _layanan.keluar(_token!);
      } catch (_) {}
    }
    _token = null;
    _pengguna = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token_akses');
    notifyListeners();
  }
}
