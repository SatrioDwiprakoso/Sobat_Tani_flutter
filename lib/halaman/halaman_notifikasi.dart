import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_notifikasi.dart';
import '../model/model_notifikasi.dart';

class HalamanNotifikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<PenyediaNotifikasi>(
        builder: (context, provider, child) {
          final semua = provider.daftarNotifikasi;
          final hariIni = semua.where((n) => DateTime.now().difference(n.waktu).inHours <= 24).toList();
          final sebelumnya = semua.where((n) => DateTime.now().difference(n.waktu).inHours > 24).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF317A55), Color(0xFF40826D)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.chevron_left, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Notifikasi',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (provider.jumlahBelumDibaca > 0)
                      GestureDetector(
                        onTap: () => provider.tandaiSemuaDibaca(),
                        child: const Text(
                          'Tandai telah dibaca',
                          style: TextStyle(color: Color(0xFF1E5136), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              
              Expanded(
                child: semua.isEmpty 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text('Belum ada notifikasi', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                        ],
                      )
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (hariIni.isNotEmpty) ...[
                          const Text('HARI INI', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          const SizedBox(height: 12),
                          ...hariIni.map((n) => _buildNotifCard(context, n, provider)),
                          const SizedBox(height: 24),
                        ],
                        if (sebelumnya.isNotEmpty) ...[
                          const Text('SEBELUMNYA', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                          const SizedBox(height: 12),
                          ...sebelumnya.map((n) => _buildNotifCard(context, n, provider)),
                        ]
                      ],
                    ),
              )
            ],
          );
        }
      ),
    );
  }

  Widget _buildNotifCard(BuildContext context, ModelNotifikasi n, PenyediaNotifikasi provider) {
    // Format Waktu
    final diff = DateTime.now().difference(n.waktu);
    String waktuTeks = '';
    if (diff.inMinutes < 60) {
      waktuTeks = '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      waktuTeks = '${diff.inHours} jam lalu';
    } else {
      waktuTeks = '${diff.inDays} hari lalu';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => provider.tandaiDibaca(n.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isDark ? n.warnaBackground.withOpacity(0.2) : n.warnaBackground,
              child: Icon(n.ikon, color: n.warnaIkon, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.judul, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 4),
                  Text(n.pesan, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.3)),
                  const SizedBox(height: 8),
                  Text(waktuTeks, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                ],
              ),
            ),
            if (!n.dibaca)
              Container(
                margin: const EdgeInsets.only(left: 8, top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2D6A4F),
                  shape: BoxShape.circle,
                ),
              )
          ],
        ),
      ),
    );
  }
}

