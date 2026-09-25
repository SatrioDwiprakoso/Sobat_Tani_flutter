import 'dart:convert';
import 'package:http/http.dart' as http;
import '../konfigurasi/konstanta_api.dart';
import '../model/model_konsultasi.dart';

class LayananKonsultasi {
  Future<List<ModelKonsultasi>> ambilKonsultasi(String token) async {
    final response = await http.get(
      Uri.parse(KonstantaApi.konsultasi),
      headers: KonstantaApi.header(token),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => ModelKonsultasi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data konsultasi');
    }
  }

  Future<ModelKonsultasi> tambahKonsultasi(String token, String komoditas, String judul, String gejala, String urgensi, String? pathFoto) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.konsultasi));
    request.headers.addAll(KonstantaApi.header(token));
    
    request.fields['komoditas'] = komoditas;
    request.fields['judul_keluhan'] = judul;
    request.fields['deskripsi_gejala'] = gejala;
    request.fields['tingkat_urgensi'] = urgensi;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_tanaman', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ModelKonsultasi.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Gagal menambah konsultasi');
    }
  }

  Future<ModelKonsultasi> detailKonsultasi(String token, int id) async {
    final response = await http.get(
      Uri.parse('/'),
      headers: KonstantaApi.header(token),
    );
    if (response.statusCode == 200) {
      return ModelKonsultasi.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal mengambil detail konsultasi');
    }
  }

  Future<ModelPesanKonsultasi> kirimPesan(String token, int id, String? pesan, {String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse("${KonstantaApi.konsultasi}/$id/pesan"));
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (pesan != null && pesan.isNotEmpty) {
      request.fields['pesan'] = pesan;
    }

    if (pathFoto != null) {
      request.files.add(await http.MultipartFile.fromPath('foto', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ModelPesanKonsultasi.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal mengirim pesan');
    }
  }

  Future<ModelKonsultasi> tandaiSelesai(String token, int id) async {
    final response = await http.put(
      Uri.parse("${KonstantaApi.konsultasi}/$id/selesai"),
      headers: KonstantaApi.header(token),
    );

    if (response.statusCode == 200) {
      return ModelKonsultasi.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal menandai selesai');
    }
  }
}
