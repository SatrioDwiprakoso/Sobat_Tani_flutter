import 'package:flutter/material.dart';

class ModelNotifikasi {
  final String id;
  final String judul;
  final String pesan;
  final DateTime waktu;
  final IconData ikon;
  final Color warnaIkon;
  final Color warnaBackground;
  bool dibaca;

  ModelNotifikasi({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    required this.ikon,
    required this.warnaIkon,
    required this.warnaBackground,
    this.dibaca = false,
  });
}
