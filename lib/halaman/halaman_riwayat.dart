import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_konsultasi.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'widget_shimmer.dart';
import 'halaman_detail_konsultasi.dart';
import 'halaman_detail_pengaduan.dart';
import '../model/model_konsultasi.dart';
import '../model/model_pengaduan.dart';
import '../penyedia/penyedia_pengaduan.dart';


class HalamanRiwayat extends StatefulWidget {
  @override
  _HalamanRiwayatState createState() => _HalamanRiwayatState();
}

class _HalamanRiwayatState extends State<HalamanRiwayat> {
  int _tabIndex = 0; // 0 = Konsultasi, 1 = Pengaduan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            color: const Color(0xFF40826D),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              left: 24, right: 24, bottom: 24
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riwayat Layanan', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                // Custom Tab Toggle
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = 0),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _tabIndex == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text('Konsultasi', style: TextStyle(
                              color: _tabIndex == 0 ? const Color(0xFF40826D) : Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.bold, fontSize: 13
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _tabIndex = 1),
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: _tabIndex == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text('Pengaduan', style: TextStyle(
                              color: _tabIndex == 1 ? const Color(0xFF40826D) : Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.bold, fontSize: 13
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
                if (token != null) {
                  if (_tabIndex == 0) {
                    await Provider.of<PenyediaKonsultasi>(context, listen: false).ambilKonsultasi(token);
                  } else {
                    await Provider.of<PenyediaPengaduan>(context, listen: false).ambilPengaduan(token);
                  }
                }
              },
              child: _tabIndex == 0 ? _buildListKonsultasi() : _buildListPengaduan(),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
      if (token != null) {
        Provider.of<PenyediaKonsultasi>(context, listen: false).ambilKonsultasi(token);
      }
    });
  }

  Widget _buildListKonsultasi() {
    return Consumer<PenyediaKonsultasi>(
      builder: (context, provider, child) {
        if (provider.memuat) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            itemCount: 4, // Tampilkan 4 skeleton
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const WidgetShimmer(width: 60, height: 60, borderRadius: 12),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const WidgetShimmer(width: double.infinity, height: 14),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                WidgetShimmer(width: 40, height: 14),
                                SizedBox(width: 8),
                                WidgetShimmer(width: 60, height: 14),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const WidgetShimmer(width: 80, height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (provider.pesanError != null) {
          return Center(child: Text(provider.pesanError!));
        }
        if (provider.daftarKonsultasi.isEmpty) {
          return const Center(child: Text('Belum ada riwayat konsultasi.', style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
          itemCount: provider.daftarKonsultasi.length + 1, // +1 untuk teks bawah
          itemBuilder: (context, index) {
            if (index == provider.daftarKonsultasi.length) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Center(child: Text('${provider.daftarKonsultasi.length} riwayat ditampilkan', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))),
                  const SizedBox(height: 100),
                ],
              );
            }
            
            final data = provider.daftarKonsultasi[index];
            Color statusColor = data.status == 'selesai' ? Colors.green : (data.status == 'dijawab' ? Colors.blue : Colors.orange);
            String statusText = data.status == 'selesai' ? 'Selesai Dijawab' : (data.status == 'dijawab' ? 'Dijawab' : 'Menunggu');
            String dateText = data.createdAt.length > 10 ? data.createdAt.substring(0, 10) : data.createdAt;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildItemKonsultasi(data, dateText, statusText, statusColor),
            );
          },
        );
      },
    );
  }

  Widget _buildItemKonsultasi(ModelKonsultasi data, String date, String status, Color statusColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanDetailKonsultasi(data: data)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(width: 60, height: 60, color: Colors.brown.shade200, child: const Icon(Icons.image, color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.judulKeluhan, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(4)),
                        child: Text(data.komoditas, style: TextStyle(color: Colors.orange.shade800, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Text(date, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade300)
          ],
        ),
      ),
    );
  }

    Widget _buildListPengaduan() {
    return Consumer<PenyediaPengaduan>(
      builder: (context, provider, child) {
        if (provider.memuat) {
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      const WidgetShimmer(width: 48, height: 48, borderRadius: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const WidgetShimmer(width: double.infinity, height: 14),
                            const SizedBox(height: 8),
                            const WidgetShimmer(width: 120, height: 14),
                            const SizedBox(height: 8),
                            const WidgetShimmer(width: 80, height: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (provider.pesanError != null) {
          return Center(child: Text(provider.pesanError!));
        }
        if (provider.daftarPengaduan.isEmpty) {
          return const Center(child: Text('Belum ada riwayat pengaduan.', style: TextStyle(color: Colors.grey)));
        }

        return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
          itemCount: provider.daftarPengaduan.length + 1,
          itemBuilder: (context, index) {
            if (index == provider.daftarPengaduan.length) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Center(child: Text('${provider.daftarPengaduan.length} riwayat ditampilkan', style: TextStyle(color: Colors.grey.shade400, fontSize: 12))),
                  const SizedBox(height: 100),
                ],
              );
            }
            
            final data = provider.daftarPengaduan[index];
            Color statusColor = data.status == 'selesai' ? Colors.green : (data.status == 'diproses' ? Colors.blue : Colors.orange);
            String statusText = data.status == 'selesai' ? 'Selesai' : (data.status == 'diproses' ? 'Diproses' : 'Baru/Menunggu');
            String dateText = data.createdAt.length > 10 ? data.createdAt.substring(0, 10) : data.createdAt;
            String metaText = "$dateText Â· #ADU-${data.id.toString().padLeft(3, '0')}";

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildItemPengaduan(data, metaText, statusText, statusColor),
            );
          },
        );
      },
    );
  }

  Widget _buildItemPengaduan(ModelPengaduan data, String meta, String statusText, Color statusColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanDetailPengaduan(data: data)));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.shade50,
              radius: 24,
              child: Icon(Icons.send, color: Colors.orange.shade400, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.deskripsi, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Text(meta, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 4),
                      Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}








