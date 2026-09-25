import 'package:flutter/material.dart';
import '../model/model_artikel.dart';

class HalamanDetailArtikel extends StatelessWidget {
  final ModelArtikel artikel;

  const HalamanDetailArtikel({Key? key, required this.artikel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header Image with Back button
          Stack(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF40826D),
                  image: artikel.gambarUrl != null
                      ? DecorationImage(image: NetworkImage(artikel.gambarUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: artikel.gambarUrl == null 
                    ? const Center(child: Icon(Icons.park, size: 80, color: Colors.white70))
                    : null,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
                    ),
                ),
              ),
            ],
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artikel.judul,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFE8F3EB),
                        child: Text(artikel.penulis[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D6A4F))),
                      ),
                      const SizedBox(width: 8),
                      Text(artikel.penulis, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(artikel.tanggal, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    artikel.isi,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
