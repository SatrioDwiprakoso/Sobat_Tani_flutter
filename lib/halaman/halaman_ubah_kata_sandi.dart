import 'package:flutter/material.dart';

class HalamanUbahKataSandi extends StatefulWidget {
  @override
  _HalamanUbahKataSandiState createState() => _HalamanUbahKataSandiState();
}

class _HalamanUbahKataSandiState extends State<HalamanUbahKataSandi> {
  final _sandiLamaController = TextEditingController();
  final _sandiBaruController = TextEditingController();
  final _konfirmasiController = TextEditingController();
  bool _sembunyiSandiLama = true;
  bool _sembunyiSandiBaru = true;
  bool _sembunyiKonfirmasi = true;

  @override
  Widget build(BuildContext context) {
    bool isFormValid = _sandiLamaController.text.isNotEmpty && 
                       _sandiBaruController.text.isNotEmpty && 
                       _konfirmasiController.text.isNotEmpty &&
                       _sandiBaruController.text == _konfirmasiController.text;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text('Ubah Kata Sandi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          const Text('Kata Sandi Saat Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          _buildTextField(_sandiLamaController, _sembunyiSandiLama, () => setState(() => _sembunyiSandiLama = !_sembunyiSandiLama), 'Masukkan kata sandi lama'),
                          
                          const SizedBox(height: 24),
                          
                          const Text('Kata Sandi Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          _buildTextField(_sandiBaruController, _sembunyiSandiBaru, () => setState(() => _sembunyiSandiBaru = !_sembunyiSandiBaru), 'Masukkan kata sandi baru'),
                          const SizedBox(height: 8),
                          Text('Minimal 8 karakter, kombinasi huruf dan angka', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          
                          const SizedBox(height: 24),
                          
                          const Text('Konfirmasi Kata Sandi Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                          const SizedBox(height: 8),
                          _buildTextField(_konfirmasiController, _sembunyiKonfirmasi, () => setState(() => _sembunyiKonfirmasi = !_sembunyiKonfirmasi), 'Ulangi kata sandi baru'),
                          
                          if (_sandiBaruController.text.isNotEmpty && _konfirmasiController.text.isNotEmpty && _sandiBaruController.text != _konfirmasiController.text)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text('Kata sandi tidak cocok', style: TextStyle(color: Colors.red.shade400, fontSize: 12)),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: isFormValid ? () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kata sandi berhasil diubah')));
                        Navigator.pop(context);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFormValid ? const Color(0xFF317A55) : const Color(0xFFD1D5DB),
                        disabledBackgroundColor: const Color(0xFFD1D5DB),
                        minimumSize: const Size.fromHeight(55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Simpan Kata Sandi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, bool isHidden, VoidCallback toggleVis, String hint) {
    return TextField(
      controller: controller,
      obscureText: isHidden,
      onChanged: (_) => setState((){}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF317A55))),
        suffixIcon: IconButton(
          icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade500, size: 20),
          onPressed: toggleVis,
        )
      ),
    );
  }
}

