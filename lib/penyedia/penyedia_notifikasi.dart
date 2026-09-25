import 'package:flutter/material.dart';
import '../model/model_notifikasi.dart';
import '../model/model_konsultasi.dart';
import '../model/model_pengaduan.dart';

class PenyediaNotifikasi with ChangeNotifier {
  List<ModelNotifikasi> _daftarNotifikasi = [];

  List<ModelNotifikasi> get daftarNotifikasi => _daftarNotifikasi;

  int get jumlahBelumDibaca => _daftarNotifikasi.where((n) => !n.dibaca).length;

  void perbaruiDariData(List<ModelKonsultasi> konsultasi, List<ModelPengaduan> pengaduan) {
    List<ModelNotifikasi> notifBaru = [];

    // Cek tanggapan konsultasi
    for (var k in konsultasi) {
      if (k.tanggapanAhli != null && k.tanggapanAhli!.isNotEmpty) {
        DateTime waktu = DateTime.tryParse(k.updatedAt) ?? DateTime.now();
        notifBaru.add(ModelNotifikasi(
          id: 'konsultasi_${k.id}',
          judul: 'Penyuluh membalas konsultasi ${k.komoditas}',
          pesan: k.tanggapanAhli!,
          waktu: waktu,
          ikon: Icons.chat_bubble_outline,
          warnaIkon: Colors.green.shade700,
          warnaBackground: Colors.green.shade100,
        ));
      }
      if (k.status == 'selesai') {
        DateTime waktu = DateTime.tryParse(k.updatedAt) ?? DateTime.now();
        notifBaru.add(ModelNotifikasi(
          id: 'survei_${k.id}',
          judul: 'Jangan lupa beri penilaian layanan',
          pesan: 'Konsultasi Anda sudah selesai dijawab. Isi survei SKM untuk meningkatkan layanan.',
          waktu: waktu.add(const Duration(minutes: 5)),
          ikon: Icons.star_border,
          warnaIkon: Colors.orange.shade700,
          warnaBackground: Colors.orange.shade100,
        ));
      }
    }

    // Cek status pengaduan
    for (var p in pengaduan) {
      if (p.status != 'menunggu') {
        DateTime waktu = DateTime.tryParse(p.updatedAt) ?? DateTime.now();
        String pesan = p.status == 'diproses' 
            ? 'Pengaduan ${p.kategori} sedang diproses oleh dinas terkait.' 
            : 'Pengaduan ${p.kategori} di lokasi Anda telah selesai ditangani.';
        notifBaru.add(ModelNotifikasi(
          id: 'pengaduan_${p.id}_${p.status}',
          judul: p.status == 'diproses' ? 'Status pengaduan Anda diperbarui' : 'Pengaduan ${p.kategori} selesai',
          pesan: pesan,
          waktu: waktu,
          ikon: p.status == 'diproses' ? Icons.notifications_active : Icons.check_box_outlined,
          warnaIkon: p.status == 'diproses' ? Colors.blue.shade700 : Colors.green.shade700,
          warnaBackground: p.status == 'diproses' ? Colors.blue.shade100 : Colors.green.shade100,
        ));
      }
    }

    // Sort descending by time
    notifBaru.sort((a, b) => b.waktu.compareTo(a.waktu));

    // Preserve read status from existing
    for (var baru in notifBaru) {
      try {
        var lama = _daftarNotifikasi.firstWhere((n) => n.id == baru.id);
        baru.dibaca = lama.dibaca;
      } catch (e) {
        // Not found, keep default
      }
    }

    _daftarNotifikasi = notifBaru;
    notifyListeners();
  }

  void tandaiSemuaDibaca() {
    for (var n in _daftarNotifikasi) {
      n.dibaca = true;
    }
    notifyListeners();
  }

  void tandaiDibaca(String id) {
    try {
      var n = _daftarNotifikasi.firstWhere((e) => e.id == id);
      n.dibaca = true;
      notifyListeners();
    } catch (e) {
      // ignore
    }
  }
}
