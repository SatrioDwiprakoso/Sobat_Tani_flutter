import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../layanan/layanan_cuaca.dart';
import '../model/model_cuaca.dart';

class PenyediaCuaca with ChangeNotifier {
  final LayananCuaca _layanan = LayananCuaca();
  ModelCuaca? _cuaca;
  bool _memuat = false;
  String? _pesanError;

  ModelCuaca? get cuaca => _cuaca;
  bool get memuat => _memuat;
  String? get pesanError => _pesanError;

  Future<void> ambilCuacaSaatIni() async {
    _memuat = true;
    _pesanError = null;
    notifyListeners();

    try {
      bool layananAktif = await Geolocator.isLocationServiceEnabled();
      if (!layananAktif) {
        throw Exception('Layanan lokasi tidak aktif.');
      }

      LocationPermission izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
        if (izin == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }

      if (izin == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak secara permanen.');
      }
      Position posisi = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _cuaca = await _layanan.ambilCuaca(posisi.latitude, posisi.longitude);
    } catch (e) {
      _pesanError = e.toString();
    } finally {
      _memuat = false;
      notifyListeners();
    }
  }
}
