import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../penyedia/penyedia_autentikasi.dart';
import 'halaman_utama.dart';
import 'halaman_daftar.dart';

// Komponen Background Daun Reusable
class LatarDaunSobatTani extends StatelessWidget {
  final Widget child;
  const LatarDaunSobatTani({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background Hijau dengan Daun
          Container(
            height: 380,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF40826D),
            ),
            child: Stack(
              children: [
                Positioned(top: -20, left: -40, child: Transform.rotate(angle: 0.5, child: Icon(Icons.energy_savings_leaf, size: 180, color: Colors.white.withOpacity(0.08)))),
                Positioned(top: 100, right: -50, child: Transform.rotate(angle: -0.2, child: Icon(Icons.energy_savings_leaf, size: 150, color: Colors.white.withOpacity(0.08)))),
                Positioned(bottom: -30, left: 100, child: Transform.rotate(angle: 0.8, child: Icon(Icons.energy_savings_leaf, size: 200, color: Colors.white.withOpacity(0.08)))),
                
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: const Color(0xFFF0FDF4),
                            child: const Icon(Icons.nature_people, size: 40, color: Color(0xFF40826D)),
                          ),
                          const SizedBox(height: 12),
                          Text('Sobat Tani', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).cardColor, letterSpacing: 0.5)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Form Content
          child,
        ],
      ),
    );
  }
}

class HalamanMasuk extends StatefulWidget {
  @override
  _HalamanMasukState createState() => _HalamanMasukState();
}

class _HalamanMasukState extends State<HalamanMasuk> {
  final _emailController = TextEditingController();
  final _sandiController = TextEditingController();
  bool _lihatSandi = false;

  void _login() async {
    final provider = Provider.of<PenyediaAutentikasi>(context, listen: false);
    bool sukses = await provider.masuk(_emailController.text, _sandiController.text);
    
    if (!mounted) return;

    if (sukses) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HalamanUtama()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.error_outline, color: Colors.white), const SizedBox(width: 10), Expanded(child: Text(provider.pesanError ?? 'Terjadi kesalahan'))]), backgroundColor: Colors.red.shade600, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), margin: const EdgeInsets.all(20)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LatarDaunSobatTani(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 220),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Selamat Datang!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                const SizedBox(height: 6),
                Text('Masuk untuk mengakses layanan konsultasi.', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                const SizedBox(height: 32),
                
                // Form Fields
                _buildTextField('Email', 'Masukan Email anda', Icons.email_outlined, _emailController),
                const SizedBox(height: 16),
                _buildTextField('Kata Sandi', 'Masukkan kata sandi', Icons.lock_outline, _sandiController, isPassword: true),
                
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Lupa Kata Sandi?', style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xFF317A55), fontSize: 13)),
                ),
                
                const SizedBox(height: 24),
                
                // Button Masuk
                Consumer<PenyediaAutentikasi>(
                  builder: (context, provider, child) {
                    return provider.memuat
                        ? const Center(child: CircularProgressIndicator(color: Color(0xFF317A55)))
                        : ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF317A55),
                              minimumSize: const Size.fromHeight(55),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                            ),
                            child: const Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          );
                  }
                ),
                
                const SizedBox(height: 24),
                
                // Divider Atau
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('atau', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Google Button
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red), // Placeholder for Google icon
                  label: const Text('Login dengan Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Belum punya akun? ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HalamanDaftar())),
                      child: const Text('Daftar Sekarang', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF317A55), fontSize: 13)),
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

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !_lihatSandi,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(_lihatSandi ? Icons.visibility : Icons.visibility_off, color: Colors.grey.shade400, size: 20),
                  onPressed: () => setState(() => _lihatSandi = !_lihatSandi),
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



