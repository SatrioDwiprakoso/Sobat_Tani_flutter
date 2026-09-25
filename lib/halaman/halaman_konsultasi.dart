import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_konsultasi.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'halaman_tambah_konsultasi.dart';
import 'halaman_survei_kepuasan.dart';

class HalamanKonsultasi extends StatefulWidget {
  @override
  _HalamanKonsultasiState createState() => _HalamanKonsultasiState();
}

class _HalamanKonsultasiState extends State<HalamanKonsultasi> {
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

  @override
  Widget build(BuildContext context) {
    final penyedia = Provider.of<PenyediaKonsultasi>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Konsultasi Tanaman', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
      body: penyedia.memuat
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2D6A4F)))
          : penyedia.pesanError != null
              ? Center(child: Text(penyedia.pesanError!))
              : penyedia.daftarKonsultasi.isEmpty
                  ? const Center(child: Text('Belum ada konsultasi.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: penyedia.daftarKonsultasi.length,
                      itemBuilder: (context, index) {
                        final item = penyedia.daftarKonsultasi[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(item.judulKeluhan, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Komoditas: ${item.komoditas}\nStatus: ${item.status}'),
                            trailing: item.status == 'selesai' 
                                ? IconButton(
                                    icon: const Icon(Icons.star_rate, color: Colors.orange),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanSurveiKepuasan(konsultasiId: item.id)));
                                    },
                                  )
                                : const Icon(Icons.hourglass_empty, color: Colors.grey),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D6A4F),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanTambahKonsultasi()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

