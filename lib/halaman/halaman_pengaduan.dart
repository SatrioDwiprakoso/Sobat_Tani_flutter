import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../layanan/layanan_pengaduan.dart';
import '../model/model_pengaduan.dart';
import '../penyedia/penyedia_autentikasi.dart';

class HalamanPengaduan extends StatefulWidget {
  @override
  _HalamanPengaduanState createState() => _HalamanPengaduanState();
}

class _HalamanPengaduanState extends State<HalamanPengaduan> {
  final LayananPengaduan _layanan = LayananPengaduan();
  List<ModelPengaduan> _daftarPengaduan = [];
  bool _memuat = true;

  final _lokasiController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String _kategoriPilihan = 'infrastruktur';
  File? _foto;

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future<void> _ambilData() async {
    final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
    if (token != null) {
      try {
        final data = await _layanan.ambilPengaduan(token);
        setState(() {
          _daftarPengaduan = data;
          _memuat = false;
        });
      } catch (e) {
        setState(() => _memuat = false);
      }
    }
  }

  void _kirimPengaduan() async {
    final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
    if (token == null) return;

    setState(() => _memuat = true);
    try {
      final baru = await _layanan.tambahPengaduan(
        token,
        _kategoriPilihan,
        _lokasiController.text,
        _deskripsiController.text,
        _foto?.path,
      );
      setState(() {
        _daftarPengaduan.insert(0, baru);
        _memuat = false;
        _lokasiController.clear();
        _deskripsiController.clear();
        _foto = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengaduan berhasil dikirim')));
    } catch (e) {
      setState(() => _memuat = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengirim pengaduan')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Layanan Pengaduan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF2D6A4F),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
          ),
        ),
      ),
      body: _memuat
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A4F)))
          : RefreshIndicator(
              onRefresh: _ambilData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildForm(),
                  const SizedBox(height: 24),
                  const Text('Riwayat Pengaduan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F))),
                  const SizedBox(height: 12),
                  ..._daftarPengaduan.map((p) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          title: Text(p.kategori.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${p.deskripsi}\nStatus: ${p.status}'),
                          isThreeLine: true,
                        ),
                      )).toList(),
                  if (_daftarPengaduan.isEmpty) const Text('Belum ada pengaduan.'),
                ],
              ),
            ),
    );
  }

  Widget _buildForm() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buat Pengaduan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategoriPilihan,
              decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'infrastruktur', child: Text('Infrastruktur')),
                DropdownMenuItem(value: 'pupuk', child: Text('Pupuk')),
                DropdownMenuItem(value: 'hama', child: Text('Hama')),
                DropdownMenuItem(value: 'layanan_publik', child: Text('Layanan Publik')),
              ],
              onChanged: (v) => setState(() => _kategoriPilihan = v!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lokasiController,
              decoration: const InputDecoration(labelText: 'Lokasi Kebun', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
                if (img != null) setState(() => _foto = File(img.path));
              },
              icon: const Icon(Icons.camera_alt),
              label: Text(_foto == null ? 'Ambil Bukti Foto' : 'Foto Terpilih'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _kirimPengaduan,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D6A4F), minimumSize: const Size.fromHeight(45)),
              child: const Text('Kirim Pengaduan'),
            ),
          ],
        ),
      ),
    );
  }
}





