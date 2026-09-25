import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_autentikasi.dart';
import '../penyedia/penyedia_tema.dart';
import 'halaman_masuk.dart';
import '../konfigurasi/konstanta_api.dart';
import 'halaman_informasi_akun.dart';
import 'halaman_panduan_penggunaan.dart';

class HalamanProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<PenyediaAutentikasi>(context).pengguna;
    final inisial = pengguna?.namaLengkap.isNotEmpty == true
        ? pengguna!.namaLengkap[0].toUpperCase()
        : 'P';
    final nama = pengguna?.namaLengkap ?? 'Pengguna';
    final email = pengguna?.email ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header Green
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color(0xFF317A55), Color(0xFF4AA57A)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                )),
              ),
              Positioned(
                top: -50,
                left: -50,
                child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white.withOpacity(0.05)),
              ),
              Positioned(
                bottom: -50,
                right: -20,
                child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.white.withOpacity(0.05)),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 24),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage: pengguna?.fotoProfil != null
                              ? NetworkImage(
                                  '${KonstantaApi.urlUtama}/storage/${pengguna!.fotoProfil}')
                              : null,
                          child: pengguna?.fotoProfil == null
                              ? Text(inisial,
                                  style: TextStyle(
                                      color: Theme.of(context).cardColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold))
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nama,
                              style: TextStyle(
                                  color: Theme.of(context).cardColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(email,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PENGATURAN',
                      style: TextStyle(
                          color: Colors.blueGrey.shade300,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                            context,
                            Icons.person,
                            Colors.blue.shade700,
                            'Informasi Akun',
                            null,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HalamanInformasiAkun()))),
                        Divider(height: 1, color: Colors.grey.shade100),
                        _buildListTile(
                            context,
                            Icons.menu_book,
                            Colors.blueGrey.shade600,
                            'Panduan Penggunaan',
                            null,
                            () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        HalamanPanduanPenggunaan()))),
                        Divider(height: 1, color: Colors.grey.shade100),
                        _buildListTile(
                            context,
                            Icons.eco,
                            Colors.green.shade700,
                            'Tentang Klinik Tani',
                            null,
                            () {}),
                        Divider(height: 1, color: Colors.grey.shade100),
                        Consumer<PenyediaTema>(builder: (context, tema, child) {
                          return ListTile(
                            leading: Icon(Icons.dark_mode_outlined),
                            title: Text('Mode Gelap'),
                            trailing: Switch(
                              value: tema.isDarkMode,
                              onChanged: (val) => tema.toggleTema(),
                              activeColor: const Color(0xFF317A55),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Text('Yakin ingin keluar?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              content: Text(
                                  'Sesi Anda akan berakhir dan Anda harus masuk kembali.',
                                  style: TextStyle(fontSize: 14)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Tidak',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await Provider.of<PenyediaAutentikasi>(
                                            context,
                                            listen: false)
                                        .keluar();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => HalamanMasuk()),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0,
                                  ),
                                  child: Text('Ya, Keluar',
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.logout, color: Colors.red),
                    label: Text('Keluar dari Akun',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size.fromHeight(55),
                      backgroundColor: const Color(0xFFFFF0F0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 100), // Spacing for bottom nav
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, Color iconColor,
      String title, String? subtitle, VoidCallback onTap,
      {bool isSwitch = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade50,
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyLarge?.color ??
                  Colors.black87)),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11))
          : null,
      trailing: isSwitch
          ? Switch(
              value: false,
              onChanged: (v) {},
              activeColor: const Color(0xFF317A55))
          : Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
      onTap: isSwitch ? null : onTap,
    );
  }
}
