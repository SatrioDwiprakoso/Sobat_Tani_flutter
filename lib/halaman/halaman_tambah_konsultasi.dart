import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../layanan/layanan_konsultasi.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'halaman_sukses_konsultasi.dart';

class HalamanTambahKonsultasi extends StatefulWidget {
  @override
  _HalamanTambahKonsultasiState createState() => _HalamanTambahKonsultasiState();
}

class _HalamanTambahKonsultasiState extends State<HalamanTambahKonsultasi> {
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  String? _komoditasPilihan;
  File? _foto;
  bool _memuat = false;


  void _pilihSumberFoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
                  if (img != null) setState(() => _foto = File(img.path));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);
                  if (img != null) setState(() => _foto = File(img.path));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _kirim() async {
    if (_komoditasPilihan == null || _judulController.text.isEmpty || _deskripsiController.text.isEmpty || _foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text('Harap isi semua kolom ber-bintang merah (*)'))]), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(20)));
      return;
    }

    final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
    if (token == null) return;

    setState(() => _memuat = true);
    try {
      await LayananKonsultasi().tambahKonsultasi(
        token,
        _komoditasPilihan!,
        _judulController.text,
        _deskripsiController.text,
        'sedang', // Default
        _foto!.path,
      );
      setState(() => _memuat = false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HalamanSuksesKonsultasi()));
    } catch (e) {
      setState(() => _memuat = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(e.toString().replaceAll('Exception: ', '')))]), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(20)));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid = _komoditasPilihan != null && _judulController.text.isNotEmpty && _deskripsiController.text.isNotEmpty && _foto != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header Kustom
          Container(
            color: const Color(0xFF40826D),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24, right: 24, bottom: 24
            ),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Konsultasi Tanaman', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Isi formulir dengan lengkap', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          
          // Form Konten
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Pilih Komoditas'),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Pilih komoditas...', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                        value: _komoditasPilihan,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        items: ['Kelapa', 'Kakao', 'Kopi'].map((e) => DropdownMenuItem(value: e.toLowerCase(), child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                        onChanged: (val) => setState(() => _komoditasPilihan = val),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildLabel('Judul Gejala'),
                  TextField(
                    controller: _judulController,
                    onChanged: (_) => setState((){}),
                    decoration: InputDecoration(
                      hintText: 'Judul gejala yang anda sedang hadapi',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF40826D))),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildLabel('Foto Bagian Tanaman'),
                  GestureDetector(
                    onTap: _pilihSumberFoto,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4), // Sangat muda hijau
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF40826D).withOpacity(0.5), width: 1.5, style: BorderStyle.solid), // Mensimulasikan garis batas desain
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(color: Color(0xFF40826D), shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 24),
                          ),
                          const SizedBox(height: 12),
                          Text(_foto == null ? 'Ambil Foto Tanaman' : 'Foto Berhasil Terpilih', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                          const SizedBox(height: 4),
                          Text('Pastikan foto jelas dan terang', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  _buildLabel('Deskripsi Gejala'),
                  TextField(
                    controller: _deskripsiController,
                    onChanged: (_) => setState((){}),
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Jelaskan gejala yang terlihat pada tanaman Anda.\nContoh: Daun kakao menguning dari tepi, kemudian mongering, dan mulai rontok sejak 3 hari lalu...',
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13, height: 1.5),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF40826D))),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(alignment: Alignment.centerRight, child: Text('0 karakter', style: TextStyle(color: Colors.grey.shade400, fontSize: 11))),
                  
                  const SizedBox(height: 32),
                  
                  _memuat 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF40826D)))
                    : ElevatedButton(
                        onPressed: isFormValid ? _kirim : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFormValid ? const Color(0xFF40826D) : const Color(0xFFD1D5DB),
                          disabledBackgroundColor: const Color(0xFFD1D5DB),
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Kirim Konsultasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1E293B), fontSize: 13),
          children: const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
        ),
      ),
    );
  }
}


