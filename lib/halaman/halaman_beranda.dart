import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../penyedia/penyedia_tema.dart';
import '../penyedia/penyedia_autentikasi.dart';
import '../penyedia/penyedia_konsultasi.dart';
import '../penyedia/penyedia_pengaduan.dart';
import '../penyedia/penyedia_cuaca.dart';
import '../penyedia/penyedia_artikel.dart';
import '../penyedia/penyedia_notifikasi.dart';
import 'halaman_profil.dart';
import 'halaman_konsultasi.dart';
import 'halaman_pengaduan.dart';
import 'halaman_tambah_konsultasi.dart';
import 'halaman_tambah_pengaduan.dart';
import '../model/model_konsultasi.dart';
import 'halaman_detail_artikel.dart';
import 'halaman_artikel.dart';
import 'halaman_riwayat.dart';
import 'widget_shimmer.dart';
import 'halaman_notifikasi.dart';

class HalamanBeranda extends StatefulWidget {
  @override
  _HalamanBerandaState createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<PenyediaCuaca>(context, listen: false).ambilCuacaSaatIni();
      Provider.of<PenyediaArtikel>(context, listen: false).ambilArtikel();
      final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
      if (token != null) {
        final provKonsultasi = Provider.of<PenyediaKonsultasi>(context, listen: false);
        final provPengaduan = Provider.of<PenyediaPengaduan>(context, listen: false);
        await Future.wait([
          provKonsultasi.ambilKonsultasi(token),
          provPengaduan.ambilPengaduan(token),
        ]);
        
        Provider.of<PenyediaNotifikasi>(context, listen: false).perbaruiDariData(
          provKonsultasi.daftarKonsultasi,
          provPengaduan.daftarPengaduan
        );
      }
    });
  }


  Future<void> _refreshData() async {
    final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
    if (token != null) {
      final penyediaKonsultasi = Provider.of<PenyediaKonsultasi>(context, listen: false);
      final penyediaPengaduan = Provider.of<PenyediaPengaduan>(context, listen: false);
      await penyediaKonsultasi.ambilKonsultasi(token);
      await penyediaPengaduan.ambilPengaduan(token);
      Provider.of<PenyediaNotifikasi>(context, listen: false).perbaruiDariData(penyediaKonsultasi.daftarKonsultasi, penyediaPengaduan.daftarPengaduan);
    }
    Provider.of<PenyediaArtikel>(context, listen: false).ambilArtikel();
    await Future.delayed(const Duration(seconds: 1));
  }

  String _sapaanBerdasarkanWaktu() {
    var jam = DateTime.now().hour;
    if (jam >= 4 && jam < 11) {
      return 'Selamat Pagi,';
    } else if (jam >= 11 && jam < 15) {
      return 'Selamat Siang,';
    } else if (jam >= 15 && jam < 18) {
      return 'Selamat Sore,';
    } else {
      return 'Selamat Malam,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final namaLengkap = Provider.of<PenyediaAutentikasi>(context).pengguna?.namaLengkap ?? 'Pengguna';
    final inisial = namaLengkap.isNotEmpty ? namaLengkap.substring(0, 1).toUpperCase() : 'P';
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Latar Hijau Atas
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: Color(0xFF2D6A4F),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
          ),
          
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_sapaanBerdasarkanWaktu(), style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            Text(namaLengkap, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        Consumer<PenyediaNotifikasi>(
                          builder: (context, notifProv, child) {
                            int notifCount = notifProv.jumlahBelumDibaca;
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanNotifikasi())),
                                  child: CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.white.withOpacity(0.15),
                                    child: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
                                  ),
                                ),
                                if (notifCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                                      child: Text('$notifCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  )
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                  
                  // KARTU CUACA
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: _buildKartuCuaca(),
                  ),

                  const SizedBox(height: 16),

                  // LAYANAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text('Layanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
                  ),
                  const SizedBox(height: 16),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanTambahKonsultasi())),
                            child: _buildKartuLayanan(Icons.eco, 'Konsultasi\nTanaman', const Color(0xFF40826D)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanTambahPengaduan())),
                            child: _buildKartuLayanan(Icons.send, 'Layanan\nPengaduan', Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ARTIKEL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Artikel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanArtikel())),
                          child: const Text('Lihat Semua \u2192', style: TextStyle(color: Color(0xFF317A55), fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                  
                  SizedBox(
                    height: 230,
                    child: Consumer<PenyediaArtikel>(
                      builder: (context, prov, child) {
                        if (prov.memuat) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF317A55)));
                        }
                        if (prov.pesanError != null) {
                          return Center(child: Text(prov.pesanError!));
                        }
                        if (prov.daftarArtikel.isEmpty) {
                          return const Center(child: Text('Belum ada artikel.'));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: prov.daftarArtikel.length,
                          itemBuilder: (context, index) {
                            final artikel = prov.daftarArtikel[index];
                            return Padding(
                              padding: EdgeInsets.only(right: index == prov.daftarArtikel.length - 1 ? 0 : 16),
                              child: _buildKartuArtikelHorizontal(context, artikel),
                            );
                          }
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKartuCuaca() {
    return Consumer<PenyediaCuaca>(
      builder: (context, cuacaProvider, child) {
        bool memuat = cuacaProvider.memuat;

        if (memuat) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WidgetShimmer(width: 150, height: 16),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetShimmer(width: 80, height: 60),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            WidgetShimmer(width: 100, height: 16),
                            SizedBox(height: 8),
                            WidgetShimmer(width: 80, height: 24, borderRadius: 12),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const WidgetShimmer(width: 60, height: 60, borderRadius: 30),
              ],
            ),
          );
        }

        String suhu = '${cuacaProvider.cuaca?.suhu ?? 28}';
        String kondisi = cuacaProvider.cuaca?.kondisi ?? 'Cerah Berawan';
        String kota = cuacaProvider.cuaca?.kota ?? 'Cibinong';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cuaca Hari Ini \u00B7 $kota', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$suhu\u00B0', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, height: 1.0)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kondisi, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8F3DC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('Cocok berkebun', style: TextStyle(color: Color(0xFF317A55), fontSize: 10, fontWeight: FontWeight.bold)),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              WidgetAnimasiCuaca(kondisi: kondisi),
            ],
          ),
        );
      }
    );
  }

  Widget _buildKartuLayanan(IconData icon, String title, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor,
            child: Icon(icon, color: Theme.of(context).cardColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildKartuArtikelHorizontal(BuildContext context, dynamic artikel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanDetailArtikel(artikel: artikel)));
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF81C784),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                image: artikel.gambarUrl != null 
                    ? DecorationImage(image: NetworkImage(artikel.gambarUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: artikel.gambarUrl == null 
                  ? const Center(child: Icon(Icons.park, size: 50, color: Colors.white70))
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artikel.tanggal,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Animasi Cuaca
class WidgetAnimasiCuaca extends StatefulWidget {
  final String kondisi;
  const WidgetAnimasiCuaca({Key? key, required this.kondisi}) : super(key: key);
  @override
  _WidgetAnimasiCuacaState createState() => _WidgetAnimasiCuacaState();
}

class _WidgetAnimasiCuacaState extends State<WidgetAnimasiCuaca> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isHujan = widget.kondisi.toLowerCase().contains('hujan');
    if (isHujan) {
      return SizedBox(
        width: 60, height: 60,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const Icon(Icons.cloud, color: Color(0xFFB0BEC5), size: 55),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: 25 + (_controller.value * 25),
                  child: Opacity(
                    opacity: 1.0 - _controller.value,
                    child: const Icon(Icons.water_drop, color: Colors.lightBlueAccent, size: 20),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 60, height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0, right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * math.pi,
                    child: const Icon(Icons.wb_sunny, color: Color(0xFFFFCA28), size: 45),
                  );
                },
              ),
            ),
            const Positioned(bottom: 5, left: 0, child: Icon(Icons.cloud, color: Color(0xFFE0E0E0), size: 45)),
          ],
        ),
      );
    }
  }
}


