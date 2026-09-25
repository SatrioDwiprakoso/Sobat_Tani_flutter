import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_artikel.dart';
import 'halaman_detail_artikel.dart';

class HalamanArtikel extends StatefulWidget {
  @override
  _HalamanArtikelState createState() => _HalamanArtikelState();
}

class _HalamanArtikelState extends State<HalamanArtikel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PenyediaArtikel>(context, listen: false).ambilArtikel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Semua Artikel', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
      body: Consumer<PenyediaArtikel>(
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
            padding: const EdgeInsets.all(16),
            itemCount: prov.daftarArtikel.length,
            itemBuilder: (context, index) {
              final artikel = prov.daftarArtikel[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HalamanDetailArtikel(artikel: artikel)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
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
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFF81C784),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          image: artikel.gambarUrl != null
                              ? DecorationImage(image: NetworkImage(artikel.gambarUrl!), fit: BoxFit.cover)
                              : null,
                        ),
                        child: artikel.gambarUrl == null
                            ? const Center(child: Icon(Icons.park, size: 60, color: Colors.white70))
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              artikel.judul,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              artikel.ringkasan,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(artikel.penulis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF317A55))),
                                Text(artikel.tanggal, style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
