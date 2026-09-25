import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import '../konfigurasi/konstanta_api.dart';
import 'halaman_survei_kepuasan.dart';
import 'package:provider/provider.dart';
import '../model/model_konsultasi.dart';
import '../penyedia/penyedia_autentikasi.dart';
import '../penyedia/penyedia_konsultasi.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'dart:convert';

class HalamanDetailKonsultasi extends StatefulWidget {
  final ModelKonsultasi data;

  const HalamanDetailKonsultasi({Key? key, required this.data})
      : super(key: key);

  @override
  State<HalamanDetailKonsultasi> createState() =>
      _HalamanDetailKonsultasiState();
}

class _HalamanDetailKonsultasiState extends State<HalamanDetailKonsultasi> {
  final TextEditingController _pesanController = TextEditingController();
  bool _mengirim = false;
  bool _surveiDikirimLokal = false;
  File? _fotoBalasan;
  final ImagePicker _picker = ImagePicker();
   final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  @override
  void initState() {
    super.initState();
    _initPusher();
  }

  Future<void> _initPusher() async {
    try {
      await pusher.init(
        apiKey: "69df2289e0a8e7f7ac8e", // Ganti dengan Key dari web Pusher
        cluster: "ap1",
        onEvent: onPusherEvent,
      );
      
      await pusher.subscribe(channelName: "chat.konsultasi.\${widget.data.id}");
      await pusher.connect();
    } catch (e) {
      debugPrint("Error inisialisasi Pusher: \$e");
    }
  }

  void onPusherEvent(PusherEvent event) {
    debugPrint("PUSHER EVENT RECEIVED: ${event.eventName}");
    if (event.eventName == "PesanBaru" || event.eventName == ".PesanBaru") {
      if (mounted) {
        final auth = Provider.of<PenyediaAutentikasi>(context, listen: false);
        if (auth.token != null) {
          Provider.of<PenyediaKonsultasi>(context, listen: false)
              .perbaruiDetailKonsultasi(auth.token!, widget.data.id);
        }
      }
    }
  }

  @override
  void dispose() {
    pusher.unsubscribe(channelName: "chat.konsultasi.\${widget.data.id}");
    pusher.disconnect();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image != null) {
      setState(() {
        _fotoBalasan = File(image.path);
      });
    }
  }

  void _kirimPesan() async {
    if (_pesanController.text.trim().isEmpty && _fotoBalasan == null) return;

    setState(() => _mengirim = true);
    final auth = Provider.of<PenyediaAutentikasi>(context, listen: false);
    final penyedia = Provider.of<PenyediaKonsultasi>(context, listen: false);

    bool sukses = await penyedia.kirimPesan(
        auth.token!, widget.data.id, _pesanController.text.trim(),
        pathFoto: _fotoBalasan?.path);

    if (sukses) {
      _pesanController.clear();
      setState(() {
        _fotoBalasan = null;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(penyedia.pesanError ?? 'Gagal mengirim pesan')));
      }
    }
    setState(() => _mengirim = false);
  }

  void _tandaiSelesai() async {
    final auth = Provider.of<PenyediaAutentikasi>(context, listen: false);
    final penyedia = Provider.of<PenyediaKonsultasi>(context, listen: false);

    bool sukses = await penyedia.tandaiSelesai(auth.token!, widget.data.id);
    if (sukses && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konsultasi ditandai selesai.')));
      // Langsung muncul modal survei
      _tampilkanSurvei();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(penyedia.pesanError ?? 'Gagal menandai selesai')));
    }
  }

  Future<void> _tampilkanSurvei() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: HalamanSurveiKepuasan(konsultasiId: widget.data.id),
        ),
      ),
    );
    if (result == true) {
      setState(() {
        _surveiDikirimLokal = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PenyediaKonsultasi>(context);
    final currentData = provider.daftarKonsultasi
        .firstWhere((k) => k.id == widget.data.id, orElse: () => widget.data);

    Color statusColor = currentData.status == 'selesai'
        ? Colors.green
        : (currentData.status == 'dijawab' ? Colors.blue : Colors.orange);
    String statusText = currentData.status == 'selesai'
        ? 'Selesai'
        : (currentData.status == 'dijawab' ? 'Dijawab' : 'Menunggu');
    String dateText = currentData.createdAt.length > 10
        ? currentData.createdAt.substring(0, 10)
        : currentData.createdAt;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    final subtitleColor =
        isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Detail Konsultasi',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: const Color(0xFF2D6A4F),
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child:
                  const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
          ),
        ),
        actions: [
          if (currentData.status != 'selesai')
            TextButton(
              onPressed: _tandaiSelesai,
              child: const Text('Tandai Selesai',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusText,
                                style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                            Text(dateText,
                                style: TextStyle(
                                    color: subtitleColor, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(currentData.judulKeluhan,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: textColor)),
                        const SizedBox(height: 16),

                        // Image Placeholder atau Asli
                        if (currentData.fotoTanaman != null)
                          ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                "/storage/",
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, trace) => Container(
                                  width: double.infinity,
                                  height: 180,
                                  decoration: BoxDecoration(
                                      color: Colors.brown.shade200,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.white, size: 60),
                                ),
                              ))
                        else
                          Container(
                            width: double.infinity,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.brown.shade200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.image,
                                color: Colors.white, size: 60),
                          ),
                        const SizedBox(height: 20),

                        Text('Deskripsi Gejala',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: textColor)),
                        const SizedBox(height: 8),
                        Text(
                          currentData.deskripsiGejala,
                          style: TextStyle(
                              color: subtitleColor, fontSize: 14, height: 1.5),
                        ),

                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),

                        Text('Thread Diskusi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: textColor)),
                        const SizedBox(height: 16),

                        if (currentData.tanggapanAhli != null &&
                            currentData.tanggapanAhli!.isNotEmpty &&
                            currentData.pesan.isEmpty)
                          _buildChatBubble(
                            name: 'Sobat Tani Admin',
                            message: currentData.tanggapanAhli!,
                            foto: null,
                            isMe: false,
                            date: currentData.updatedAt.length > 10
                                ? currentData.updatedAt.substring(0, 10)
                                : currentData.updatedAt,
                            isDarkMode: isDarkMode,
                          ),

                        if (currentData.pesan.isNotEmpty)
                          ...currentData.pesan.map((p) {
                            bool isMe = p.penggunaId == currentData.penggunaId;
                            String date = p.createdAt.length > 10
                                ? p.createdAt.substring(0, 10)
                                : p.createdAt;
                            String name = isMe
                                ? 'Anda'
                                : (p.namaPengguna +
                                    (p.peranPengguna == 'admin'
                                        ? ' (Admin)'
                                        : ' (Penyuluh)'));
                            return _buildChatBubble(
                                name: name,
                                message: p.pesan ?? '',
                                foto: p.foto,
                                isMe: isMe,
                                date: date,
                                isDarkMode: isDarkMode);
                          }).toList(),

                        if (currentData.status == 'menunggu' &&
                            currentData.pesan.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isDarkMode
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.grey),
                                SizedBox(width: 12),
                                Expanded(
                                    child: Text(
                                        'Pertanyaan Anda sedang ditinjau dan akan segera dijawab oleh penyuluh pertanian kami.',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (currentData.status == 'menunggu')
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom + 8
                      : 16),
              color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
              child: const Center(
                child: Text('Menunggu respon dari penyuluh...',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
            )
          else if (currentData.status == 'selesai')
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom + 8
                      : 16),
              color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Konsultasi ini telah selesai.',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                  if (currentData.isSurveiDiisi || _surveiDikirimLokal) ...[
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFF2D6A4F), size: 18),
                        SizedBox(width: 8),
                        Text('Survei Kepuasan telah diisi',
                            style: TextStyle(
                                color: Color(0xFF2D6A4F),
                                fontWeight: FontWeight.bold)),
                      ],
                    )
                  ] else ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _tampilkanSurvei,
                      icon:
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                      label: const Text('Beri Nilai Survei Kepuasan',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D6A4F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                      ),
                    )
                  ]
                ],
              ),
            )
          else
            Container(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 12,
                  bottom: MediaQuery.of(context).padding.bottom > 0
                      ? MediaQuery.of(context).padding.bottom
                      : 12),
              decoration: BoxDecoration(color: cardColor, boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2))
              ]),
              child: Column(
                children: [
                  if (_fotoBalasan != null)
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                image: FileImage(_fotoBalasan!),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: -5,
                          top: -5,
                          child: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () =>
                                setState(() => _fotoBalasan = null),
                          ),
                        )
                      ],
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt,
                            color: Color(0xFF317A55)),
                        onPressed: _pilihFoto,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _pesanController,
                          style: TextStyle(color: textColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: currentData.status == 'dijawab'
                                ? 'Ada yang belum jelas? Tanya di sini'
                                : 'Ketik balasan...',
                            hintStyle:
                                TextStyle(color: subtitleColor, fontSize: 13),
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.grey.shade900
                                : Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _mengirim ? null : _kirimPesan,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF317A55),
                            shape: BoxShape.circle,
                          ),
                          child: _mengirim
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.send,
                                  color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildChatBubble(
      {required String name,
      required String message,
      String? foto,
      required bool isMe,
      required String date,
      required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isMe) ...[
                Text(name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.green.shade300
                            : const Color(0xFF317A55))),
                const SizedBox(width: 8),
                Text(date,
                    style:
                        TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ] else ...[
                Text(date,
                    style:
                        TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                const SizedBox(width: 8),
                Text(name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700)),
              ]
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isMe
                  ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100)
                  : (isDarkMode
                      ? const Color(0xFF1E3A2B)
                      : const Color(0xFFF0FDF4)),
              borderRadius: BorderRadius.circular(16).copyWith(
                topLeft:
                    isMe ? const Radius.circular(16) : const Radius.circular(4),
                topRight:
                    isMe ? const Radius.circular(4) : const Radius.circular(16),
              ),
              border: Border.all(
                color: isMe
                    ? (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200)
                    : (isDarkMode
                        ? const Color(0xFF2d5a40)
                        : const Color(0xFFbbf7d0)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (foto != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "/storage/",
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                        color: isMe
                            ? (isDarkMode ? Colors.white : Colors.black87)
                            : (isDarkMode
                                ? Colors.green.shade50
                                : const Color(0xFF166534)),
                        fontSize: 13,
                        height: 1.4),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
