import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_autentikasi.dart';
import '../penyedia/penyedia_pengaduan.dart';

class HalamanTambahPengaduan extends StatefulWidget {
  @override
  _HalamanTambahPengaduanState createState() => _HalamanTambahPengaduanState();
}

class _HalamanTambahPengaduanState extends State<HalamanTambahPengaduan> {
  final _lokasiController = TextEditingController();
  final _detailController = TextEditingController();
  String? _kategoriPilihan;
  File? _foto;

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

  @override
  Widget build(BuildContext context) {
    bool isFormValid =
        _kategoriPilihan != null && _detailController.text.isNotEmpty;

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(children: [
          // Header (Orange/Brown Gradient)
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF9B3E25), Color(0xFFE47A53)],
            )),
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: Colors.white, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Layanan Pengaduan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        Text('& Aspirasi Kebun',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Sampaikan keluhan atau aspirasi terkait kebun Anda. Pengaduan akan diproses oleh Dinas Pertanian setempat.',
                    style: TextStyle(
                        color: Colors.white, fontSize: 12, height: 1.5),
                  ),
                )
              ],
            ),
          ),

          // Form
          Expanded(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Kategori Pengaduan'),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: Text('Pilih kategori pengaduan...',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 13)),
                              value: _kategoriPilihan,
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.grey),
                              items: ['Infrastruktur', 'Pupuk', 'Hama']
                                  .map((e) => DropdownMenuItem(
                                      value: e.toLowerCase(),
                                      child: Text(e,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600))))
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _kategoriPilihan = val),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text('Lokasi Kejadian',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                                fontSize: 13)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _lokasiController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_on_outlined,
                                color: Color(0xFF40826D)),
                            hintText: 'Desa Sukamaju, Kec. Baolan',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Color(0xFF40826D))),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFD8F3DC),
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('GPS Otomatis',
                                        style: TextStyle(
                                            color: Color(0xFF2D6A4F),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        RichText(
                          text: TextSpan(
                            text: 'Lampiran Foto ',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E293B),
                                fontSize: 13),
                            children: [
                              TextSpan(
                                  text: '(opsional)',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.normal))
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pilihSumberFoto,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.orange.shade200,
                                  width: 1.5,
                                  style: BorderStyle.solid),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Icon(Icons.image_outlined,
                                      color: Colors.orange.shade400),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _foto == null
                                            ? 'Tambah Foto Bukti'
                                            : 'Foto Terpilih',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E293B))),
                                    const SizedBox(height: 4),
                                    Text('JPG, PNG, max 5MB',
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Detail Pengaduan'),
                        TextField(
                          controller: _detailController,
                          onChanged: (_) => setState(() {}),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText:
                                'Jelaskan secara detail permasalahan yang Anda hadapi. Sertakan waktu kejadian, dampak yang dirasakan, dan harapan Anda...',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 13,
                                height: 1.5),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide:
                                    const BorderSide(color: Color(0xFF40826D))),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                '${_detailController.text.length} / 500 karakter',
                                style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 11))),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: isFormValid
                              ? () async {
                                  final token =
                                      Provider.of<PenyediaAutentikasi>(context,
                                              listen: false)
                                          .token;
                                  if (token != null) {
                                    bool sukses =
                                        await Provider.of<PenyediaPengaduan>(
                                                context,
                                                listen: false)
                                            .tambahPengaduan(
                                      token,
                                      _kategoriPilihan!,
                                      _lokasiController.text.isNotEmpty
                                          ? _lokasiController.text
                                          : 'Lokasi GPS (Otomatis)',
                                      _detailController.text,
                                      _foto?.path,
                                    );
                                    if (sukses && mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Row(children: [
                                                const Icon(Icons.error_outline,
                                                    color: Colors.white),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    child: Text(
                                                        'Pengaduan berhasil dikirim'))
                                              ]),
                                              backgroundColor:
                                                  Colors.red.shade600,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin:
                                                  const EdgeInsets.all(20)));
                                      Navigator.pop(context);
                                    } else if (mounted) {
                                      final error =
                                          Provider.of<PenyediaPengaduan>(
                                                  context,
                                                  listen: false)
                                              .pesanError;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Row(children: [
                                                const Icon(Icons.error_outline,
                                                    color: Colors.white),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    child: Text(error ??
                                                        'Gagal mengirim pengaduan'))
                                              ]),
                                              backgroundColor:
                                                  Colors.red.shade600,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin:
                                                  const EdgeInsets.all(20)));
                                    }
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFormValid
                                ? const Color(0xFF40826D)
                                : const Color(0xFFD1D5DB),
                            disabledBackgroundColor: const Color(0xFFD1D5DB),
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Kirim Pengaduan',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        )
                      ])))
        ]));
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E293B),
              fontSize: 13),
          children: const [
            TextSpan(text: ' *', style: TextStyle(color: Colors.red))
          ],
        ),
      ),
    );
  }
}
