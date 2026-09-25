import 'dart:convert';
import 'package:http/http.dart' as http;
import '../konfigurasi/konstanta_api.dart';
import '../model/model_pengguna.dart';

class LayananAutentikasi {
  Future<Map<String, dynamic>> daftar(String nama, String email, String password, String telepon) async {
    final response = await http.post(
      Uri.parse(KonstantaApi.daftar),
      headers: {'Accept': 'application/json'},
      body: {
        'nama_lengkap': nama,
        'email': email,
        'kata_sandi': password,
        'nomor_telepon': telepon,
        'peran': 'petani',
      },
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Gagal mendaftar');
    
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}
  
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}

  Future<Map<String, dynamic>> masuk(String email, String password) async {
    final response = await http.post(
      Uri.parse(KonstantaApi.masuk),
      headers: {'Accept': 'application/json'},
      body: {
        'email': email,
        'kata_sandi': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Gagal masuk');
    
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}
  
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}

  Future<void> keluar(String token) async {
    final response = await http.post(
      Uri.parse(KonstantaApi.keluar),
      headers: KonstantaApi.header(token),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal keluar');
    
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}
  
  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}

  Future<ModelPengguna> updateProfil(String token, {String? namaLengkap, String? nomorTelepon, String? pathFoto}) async {
    var request = http.MultipartRequest('POST', Uri.parse(KonstantaApi.profil));
    request.headers.addAll(KonstantaApi.header(token));

    if (namaLengkap != null) request.fields['nama_lengkap'] = namaLengkap;
    if (nomorTelepon != null) request.fields['nomor_telepon'] = nomorTelepon;

    if (pathFoto != null && pathFoto.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('foto_profil', pathFoto));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return ModelPengguna.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal memperbarui profil');
    }
  }
}
