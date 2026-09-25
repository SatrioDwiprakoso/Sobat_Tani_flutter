import 'dart:convert';
import 'package:http/http.dart' as http;
import '../konfigurasi/konstanta_api.dart';
import '../model/model_cuaca.dart';

class LayananCuaca {
  Future<ModelCuaca> ambilCuaca(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('${KonstantaApi.cuaca}?lat=$lat&lon=$lon'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ModelCuaca.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Gagal mengambil data cuaca');
    }
  }
}
