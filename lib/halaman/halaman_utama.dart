import 'package:flutter/material.dart';
import 'halaman_beranda.dart';
import 'halaman_riwayat.dart';
import 'halaman_profil.dart';

class HalamanUtama extends StatefulWidget {
  @override
  _HalamanUtamaState createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _indeksDipilih = 0;

  final List<Widget> _halaman = [
    HalamanBeranda(),
    HalamanRiwayat(),
    HalamanProfil(),
  ];

  void _pilihHalaman(int indeks) {
    setState(() {
      _indeksDipilih = indeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _halaman[_indeksDipilih],
          
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(35), // Rounded pill shape
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Icons.home, Icons.home_outlined, 'Beranda'),
                  _buildNavItem(1, Icons.history, Icons.history, 'Riwayat'),
                  _buildNavItem(2, Icons.person, Icons.person_outline, 'Profil'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData iconAktif, IconData iconPasif, String label) {
    bool isSelected = _indeksDipilih == index;
    return GestureDetector(
      onTap: () => _pilihHalaman(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 90, // Ukuran lebar pil tetap agar rapi
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: isSelected 
            ? BoxDecoration(
                color: const Color(0xFF2D6A4F),
                borderRadius: BorderRadius.circular(30),
              )
            : const BoxDecoration(color: Colors.transparent),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? iconAktif : iconPasif, 
              color: isSelected ? Colors.white : Colors.grey.shade400, 
              size: 24
            ),
            const SizedBox(height: 4),
            Text(
              label, 
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade500, 
                fontSize: 11, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600
              )
            ),
          ],
        ),
      ),
    );
  }
}

