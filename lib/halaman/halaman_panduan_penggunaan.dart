import 'package:flutter/material.dart';

class HalamanPanduanPenggunaan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF317A55), Color(0xFF40826D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Panduan Penggunaan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Cara menggunakan Klinik Tani', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildAccordion(
                  icon: Icons.chat_bubble_outline,
                  iconColor: Colors.green.shade700,
                  bgColor: Colors.green.shade100,
                  title: 'Konsultasi Tanaman',
                  subtitle: 'Dapatkan jawaban dari penyuluh pertanian berpengalaman.',
                ),
                _buildAccordion(
                  icon: Icons.campaign_outlined,
                  iconColor: Colors.red.shade400,
                  bgColor: Colors.red.shade50,
                  title: 'Layanan Pengaduan',
                  subtitle: 'Sampaikan masalah pertanian ke Dinas terkait.',
                ),
                _buildAccordion(
                  icon: Icons.assignment_outlined,
                  iconColor: Colors.blue.shade700,
                  bgColor: Colors.blue.shade50,
                  title: 'Riwayat Layanan',
                  subtitle: 'Pantau status semua konsultasi dan pengaduan Anda.',
                ),
                _buildAccordion(
                  icon: Icons.notifications_active,
                  iconColor: Colors.orange.shade700,
                  bgColor: Colors.orange.shade100,
                  title: 'Notifikasi',
                  subtitle: 'Jangan lewatkan update penting melalui notifikasi.',
                ),
                
                const SizedBox(height: 16),
                
                // Bottom Help Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Masih bingung? Hubungi kami', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text('Tim kami siap membantu setiap hari kerja pukul 07.30â€“16.00 WIB', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone_android, color: Colors.white, size: 18),
                        label: const Text('Hubungi Via WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAccordion({required IconData icon, required Color iconColor, required Color bgColor, required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent), // Remove divider lines
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: bgColor,
            child: Icon(icon, color: iconColor),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ),
          iconColor: Colors.grey,
          collapsedIconColor: Colors.grey,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 20, bottom: 20),
              child: Text(
                'Fitur ini dirancang untuk memudahkan Anda. Cukup isi formulir yang disediakan, lampirkan foto jika perlu, lalu kirimkan. Tim kami akan segera merespons permintaan Anda melalui aplikasi ini.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}

