class ModelArtikel {
  final int id;
  final String judul;
  final String ringkasan;
  final String isi;
  final String? gambarUrl;
  final String penulis;
  final String tanggal;

  ModelArtikel({
    required this.id,
    required this.judul,
    required this.ringkasan,
    required this.isi,
    this.gambarUrl,
    required this.penulis,
    required this.tanggal,
  });

  factory ModelArtikel.fromJson(Map<String, dynamic> json) {
    return ModelArtikel(
      id: json['id'],
      judul: json['judul'],
      ringkasan: json['ringkasan'] ?? '',
      isi: json['isi'] ?? '',
      gambarUrl: json['gambar_url'],
      penulis: json['penulis'] ?? 'Admin',
      tanggal: json['created_at'] != null 
          ? json['created_at'].toString().substring(0, 10) 
          : 'Baru saja',
    );
  }
}
