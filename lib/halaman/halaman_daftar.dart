import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'halaman_masuk.dart';
import 'halaman_utama.dart';

class HalamanDaftar extends StatefulWidget {
  @override
  _HalamanDaftarState createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _teleponController = TextEditingController();
  final _sandiController = TextEditingController();
  
  bool _lihatSandi = false;
  bool _lihatSandiUlang = false;

  void _daftar() async {
    final provider = Provider.of<PenyediaAutentikasi>(context, listen: false);
    bool sukses = await provider.daftar(
      _namaController.text,
      _emailController.text,
      _sandiController.text,
      _teleponController.text,
    );
    
    if (!mounted) return;

    if (sukses) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HalamanUtama()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(provider.pesanError ?? 'Terjadi kesalahan'))]), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(20)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LatarDaunSobatTani( // Menggunakan widget reusable dari halaman_masuk.dart
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 180),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Nama', 'Masukan Nama anda', Icons.person_outline, _namaController),
                const SizedBox(height: 16),
                _buildTextField('Email', 'Masukan Email anda', Icons.email_outlined, _emailController),
                const SizedBox(height: 16),
                _buildTextField('No Handphone', 'Masukan No HP anda', Icons.phone_outlined, _teleponController),
                const SizedBox(height: 16),
                _buildTextField('Kata Sandi', 'Masukkan kata sandi', Icons.lock_outline, _sandiController, isPassword: true, isUlangi: false),
                const SizedBox(height: 16),
                _buildTextField('Ulangi Kata Sandi', 'Masukkan kata sandi', Icons.lock_outline, TextEditingController(), isPassword: true, isUlangi: true),
                
                const SizedBox(height: 32),
                
                Consumer<PenyediaAutentikasi>(
                  builder: (context, provider, child) {
                    return provider.memuat
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF317A55)))
                        : ElevatedButton(
                            onPressed: _daftar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF317A55),
                              minimumSize: const Size.fromHeight(55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                            ),
                            child: const Text('Daftar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          );
                  }
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HalamanMasuk())),
                      child: const Text('Masuk Sekarang', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF317A55), fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller, {bool isPassword = false, bool isUlangi = false}) {
    bool obscure = isPassword ? (isUlangi ? !_lihatSandiUlang : !_lihatSandi) : false;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade400, size: 20),
                  onPressed: () {
                    setState(() {
                      if (isUlangi) _lihatSandiUlang = !_lihatSandiUlang;
                      else _lihatSandi = !_lihatSandi;
                    });
                  },
                ) 
              : null,
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF317A55)),
            ),
          ),
        ),
      ],
    );
  }
}



