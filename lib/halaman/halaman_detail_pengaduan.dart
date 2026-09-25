import 'package:flutter/material.dart';
import '../model/model_pengaduan.dart';

class HalamanDetailPengaduan extends StatelessWidget {
  final ModelPengaduan data;

  const HalamanDetailPengaduan({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = data.status == 'selesai' ? Colors.green : (data.status == 'diproses' ? Colors.blue : Colors.orange);
    String statusText = data.status == 'selesai' ? 'Selesai' : (data.status == 'diproses' ? 'Diproses' : 'Menunggu Balasan');
    String dateText = data.createdAt.length > 10 ? data.createdAt.substring(0, 10) : data.createdAt;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subtitleColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Detail Pengaduan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal Lapor', style: TextStyle(color: subtitleColor, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(dateText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Status', style: TextStyle(color: subtitleColor, fontSize: 12)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ID & Kategori Tags
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text(data.kategori, style: TextStyle(color: Colors.orange.shade800, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                        child: Text('ADU-00${data.id}', style: TextStyle(color: subtitleColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Lokasi
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lokasi Kejadian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textColor)),
                            const SizedBox(height: 2),
                            Text(data.lokasiKebun, style: TextStyle(color: subtitleColor, fontSize: 13)),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Deskripsi
                  Text('Deskripsi Pengaduan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                  const SizedBox(height: 8),
                  Text(
                    data.deskripsi,
                    style: TextStyle(color: subtitleColor, fontSize: 14, height: 1.5),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Image Placeholder
                  Text('Bukti Lapangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.brown.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.image, color: Colors.white, size: 60),
                  ),
                  
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 24),
                  
                  // Tindak Lanjut Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFF317A55),
                            child: Icon(Icons.admin_panel_settings, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tindak Lanjut Dinas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textColor)),
                              Text('Sobat Tani Admin', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                      if (data.status != 'menunggu' && data.updatedAt.isNotEmpty)
                        Text(
                          data.updatedAt.length > 10 ? data.updatedAt.substring(0, 10) : data.updatedAt,
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (data.status == 'menunggu')
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(child: Text('Pengaduan Anda telah kami terima dan sedang menunggu proses investigasi oleh dinas terkait.', style: TextStyle(color: Colors.grey, fontSize: 13))),
                        ],
                      ),
                    )
                  else if (data.status == 'diproses')
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E3A5F) : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDarkMode ? const Color(0xFF2C5282) : Colors.blue.shade100),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.engineering, color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Laporan Anda sedang dalam proses penanganan / investigasi lapangan oleh petugas kami.', style: TextStyle(color: isDarkMode ? Colors.blue.shade200 : Colors.blue, fontSize: 13))),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode ? const Color(0xFF1E3A2B) : const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDarkMode ? const Color(0xFF2F855A) : const Color(0xFFbbf7d0)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: isDarkMode ? Colors.green.shade200 : const Color(0xFF166534)),
                          const SizedBox(width: 12),
                          Expanded(child: Text('Tindak lanjut telah selesai dilakukan. Terima kasih atas laporan Anda.', style: TextStyle(color: isDarkMode ? Colors.green.shade50 : const Color(0xFF166534), fontSize: 13))),
                        ],
                      ),
                    ),
                    
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
