import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'penyedia/penyedia_autentikasi.dart';
import 'penyedia/penyedia_konsultasi.dart';
import 'penyedia/penyedia_cuaca.dart';
import 'penyedia/penyedia_artikel.dart';
import 'penyedia/penyedia_artikel.dart';
import 'penyedia/penyedia_pengaduan.dart';
import 'penyedia/penyedia_notifikasi.dart';
import 'penyedia/penyedia_tema.dart';
import 'halaman/halaman_masuk.dart';
import 'halaman/halaman_utama.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PenyediaTema()),
        ChangeNotifierProvider(create: (_) => PenyediaAutentikasi()),
        ChangeNotifierProvider(create: (_) => PenyediaKonsultasi()),
        ChangeNotifierProvider(create: (_) => PenyediaCuaca()),
        ChangeNotifierProvider(create: (_) => PenyediaArtikel()),
        ChangeNotifierProvider(create: (_) => PenyediaPengaduan()),
        ChangeNotifierProvider(create: (_) => PenyediaNotifikasi()),
      ],
      child: const AplikasiKlinikTani(),
    ),
  );
}

class AplikasiKlinikTani extends StatelessWidget {
  const AplikasiKlinikTani({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PenyediaTema>(
      builder: (context, tema, child) {
        return MaterialApp(
          title: 'Sobat Tani',
          themeMode: tema.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xFF2D6A4F),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF2D6A4F),
              secondary: const Color(0xFF74C69D),
              surface: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF1B4332),
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.dark(
              primary: const Color(0xFF2D6A4F),
              secondary: const Color(0xFF74C69D),
              surface: const Color(0xFF1E1E1E),
            ),
            cardColor: const Color(0xFF1E1E1E),
          ),
          home: Consumer<PenyediaAutentikasi>(
            builder: (context, auth, child) {
              if (auth.sudahMasuk) {
                return HalamanUtama();
              } else {
                return HalamanMasuk();
              }
            },
          ),
        );
      }
    );
  }
}


