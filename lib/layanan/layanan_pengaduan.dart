import 'dart:convert';
import 'package:http/http.dart' as http;
import '../konfigurasi/konstanta_api.dart';
import '../model/model_pengaduan.dart';

class LayananPengaduan {
  Future<List<ModelPengaduan>> ambilPengaduan(String token) async {
    final response = await http.get(
      Uri.parse(KonstantaApi.pengaduan),
      headers: KonstantaApi.header(token),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => ModelPengaduan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data pengaduan');
    }
  }

  Future<ModelPengaduan> tambahPengaduan(String token, String kategori, String lokasi, String deskripsi, String? pathFoto) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.pengaduan));
    request.headers.addAll(KonstantaApi.header(token));
    
    request.fields['kategori'] = kategori;
    request.fields['lokasi_kebun'] = lokasi;
    request.fields['deskripsi'] = deskripsi;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_bukti', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ModelPengaduan.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Gagal menambah pengaduan');
    }
  }
}
