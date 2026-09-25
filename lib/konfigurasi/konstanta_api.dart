class KonstantaApi {
  static const String urlUtama = 'http://192.168.1.68:8000';
  static const String urlDasar = '$urlUtama/api';
  
  static const String daftar = '$urlDasar/daftar';
  static const String masuk = '$urlDasar/masuk';
  static const String keluar = '$urlDasar/keluar';
  static const String profil = '$urlDasar/profil';
  static const String artikel = '$urlDasar/artikel';
  
  static const String konsultasi = '$urlDasar/konsultasi';
  static const String pengaduan = '$urlDasar/pengaduan';
  static const String survei = '$urlDasar/survei';
  static const String cuaca = '$urlDasar/cuaca';

  static Map<String, String> header(String token) {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}



