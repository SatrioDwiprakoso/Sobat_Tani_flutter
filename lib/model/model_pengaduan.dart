class ModelPengaduan {
  final int id;
  final int penggunaId;
  final String kategori;
  final String lokasiKebun;
  final String deskripsi;
  final String? fotoBukti;
  final String status;
  final String createdAt;
  final String updatedAt;

  ModelPengaduan({
    required this.id,
    required this.penggunaId,
    required this.kategori,
    required this.lokasiKebun,
    required this.deskripsi,
    this.fotoBukti,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelPengaduan.fromJson(Map<String, dynamic> json) {
    return ModelPengaduan(
      id: json['id'],
      penggunaId: json['pengguna_id'],
      kategori: json['kategori'],
      lokasiKebun: json['lokasi_kebun'],
      deskripsi: json['deskripsi'],
      fotoBukti: json['foto_bukti'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? json['created_at'],
    );
  }
}
