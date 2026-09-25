import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'halaman_ubah_kata_sandi.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../konfigurasi/konstanta_api.dart';

class HalamanInformasiAkun extends StatefulWidget {
  @override
  _HalamanInformasiAkunState createState() => _HalamanInformasiAkunState();
}

class _HalamanInformasiAkunState extends State<HalamanInformasiAkun> {
  Future<void> _ubahFoto() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.camera, imageQuality: 50);
                  if (img != null) _simpanFotoProfil(img.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.gallery, imageQuality: 50);
                  if (img != null) _simpanFotoProfil(img.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpanFotoProfil(String path) async {
    final penyedia = Provider.of<PenyediaAutentikasi>(context, listen: false);
    final success = await penyedia.updateProfil(
        penyedia.pengguna!.namaLengkap, penyedia.pengguna!.nomorTelepon ?? '',
        pathFoto: path);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diubah.')));
      setState(() {});
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengubah foto profil.')));
    }
  }

  void _tampilkanSheetUbah(
      String title, String currentValue, Function(String) onSave) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow it to expand above keyboard
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ubah $title',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Masukkan $title baru',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF317A55))),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    onSave(_controller.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF317A55),
                  minimumSize: const Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Simpan Perubahan',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final penyediaAuth = Provider.of<PenyediaAutentikasi>(context);
    final pengguna = penyediaAuth.pengguna;

    final _namaLengkap = pengguna?.namaLengkap ?? 'Pengguna';
    final _email = pengguna?.email ?? 'email@contoh.com';
    final _nomorHp = pengguna?.nomorTelepon ?? 'Belum diatur';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.chevron_left, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Informasi Akun',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card Foto Profil
                    GestureDetector(
                      onTap: _ubahFoto,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 36,
                                  backgroundColor: const Color(0xFFE8F5E9),
                                  backgroundImage:
                                      Provider.of<PenyediaAutentikasi>(context)
                                                  .pengguna
                                                  ?.fotoProfil !=
                                              null
                                          ? NetworkImage('${KonstantaApi.urlUtama}/storage/${Provider.of<PenyediaAutentikasi>(context).pengguna!.fotoProfil}')
                                          : null,
                                  child:
                                      Provider.of<PenyediaAutentikasi>(context)
                                                  .pengguna
                                                  ?.fotoProfil ==
                                              null
                                          ? Text(
                                              _namaLengkap.isNotEmpty
                                                  ? _namaLengkap[0]
                                                      .toUpperCase()
                                                  : 'U',
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF317A55)),
                                            )
                                          : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF317A55),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 14),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Foto Profil',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black87)),
                                  SizedBox(height: 4),
                                  Text('Format JPEG, PNG maksimal 2MB',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Card Data Diri
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DATA DIRI',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0)),
                          const SizedBox(height: 24),
                          _buildInfoRow('Nama Lengkap', _namaLengkap, () {
                            _tampilkanSheetUbah('Nama Lengkap', _namaLengkap,
                                (val) {
                              penyediaAuth.perbaruiProfil(
                                  val, _email, _nomorHp);
                            });
                          }),
                          const SizedBox(height: 16),
                          Divider(height: 1, color: Colors.grey.shade100),
                          const SizedBox(height: 16),
                          _buildInfoRow('Alamat Email', _email, () {
                            _tampilkanSheetUbah('Alamat Email', _email, (val) {
                              penyediaAuth.perbaruiProfil(
                                  _namaLengkap, val, _nomorHp);
                            });
                          }),
                          const SizedBox(height: 16),
                          Divider(height: 1, color: Colors.grey.shade100),
                          const SizedBox(height: 16),
                          _buildInfoRow('Nomor HP', _nomorHp, () {
                            _tampilkanSheetUbah('Nomor HP', _nomorHp, (val) {
                              penyediaAuth.perbaruiProfil(
                                  _namaLengkap, _email, val);
                            });
                          }),
                          const SizedBox(height: 24),
                          Divider(height: 1, color: Colors.grey.shade100),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HalamanUbahKataSandi())),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Ubah Kata Sandi',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF317A55),
                                        fontSize: 13)),
                                Icon(Icons.chevron_right,
                                    color: Colors.grey.shade400, size: 16),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, VoidCallback onEdit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Text('Ubah',
              style: TextStyle(
                  color: Color(0xFF317A55),
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        )
      ],
    );
  }
}
