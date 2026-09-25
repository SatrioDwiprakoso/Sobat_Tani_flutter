import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../konfigurasi/konstanta_api.dart';
import '../penyedia/penyedia_autentikasi.dart';

class HalamanSurveiKepuasan extends StatefulWidget {
  final int konsultasiId;

  const HalamanSurveiKepuasan({Key? key, required this.konsultasiId}) : super(key: key);

  @override
  _HalamanSurveiKepuasanState createState() => _HalamanSurveiKepuasanState();
}

class _HalamanSurveiKepuasanState extends State<HalamanSurveiKepuasan> {
  int _rating = 5;
  final List<String> _kriteriaTersedia = ['Solusi Tepat', 'Respon Cepat', 'Ramah', 'Mudah Dipahami'];
  final List<String> _kriteriaDipilih = [];
  final _catatanController = TextEditingController();
  bool _memuat = false;

  void _kirimSurvei() async {
    setState(() => _memuat = true);
    final token = Provider.of<PenyediaAutentikasi>(context, listen: false).token;
    
    try {
      final response = await http.post(
        Uri.parse(KonstantaApi.survei),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'konsultasi_id': widget.konsultasiId,
          'rating': _rating,
          'kriteria_penilaian': _kriteriaDipilih,
          'catatan_evaluasi': _catatanController.text,
        }),
      );

      setState(() => _memuat = false);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terima kasih atas penilaian Anda!')));
        Navigator.pop(context, true);
      } else {
        final pesan = json.decode(response.body)['message'] ?? 'Gagal mengirim survei';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
      }
    } catch (e) {
      setState(() => _memuat = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Terjadi kesalahan koneksi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Survei Kepuasan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Bagaimana penilaian Anda terhadap konsultasi ini?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.orange,
                    size: 40,
                  ),
                  onPressed: () => setState(() => _rating = index + 1),
                );
              }),
            ),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('Kriteria Penilaian:', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _kriteriaTersedia.map((kriteria) {
                final dipilih = _kriteriaDipilih.contains(kriteria);
                return ChoiceChip(
                  label: Text(kriteria),
                  selected: dipilih,
                  selectedColor: const Color(0xFF74C69D),
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _kriteriaDipilih.add(kriteria);
                      } else {
                        _kriteriaDipilih.remove(kriteria);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _catatanController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Catatan Tambahan (Opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            _memuat
                ? const CircularProgressIndicator(color: Color(0xFF2D6A4F))
                : ElevatedButton(
                    onPressed: _kirimSurvei,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D6A4F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Kirim Penilaian'),
                  ),
          ],
        ),
      ),
    );
  }
}


