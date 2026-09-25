class ModelPesanKonsultasi {
  final int id;
  final int penggunaId;
  final String namaPengguna;
  final String peranPengguna;
  final String? pesan;
  final String? foto;
  final String createdAt;

  ModelPesanKonsultasi({
    required this.id,
    required this.penggunaId,
    required this.namaPengguna,
    required this.peranPengguna,
    this.pesan,
    this.foto,
    required this.createdAt,
  });

  factory ModelPesanKonsultasi.fromJson(Map<String, dynamic> json) {
    return ModelPesanKonsultasi(
      id: json['id'],
      penggunaId: json['pengguna_id'],
      namaPengguna:
          json['pengguna'] != null ? json['pengguna']['nama_lengkap'] : 'User',
      peranPengguna:
          json['pengguna'] != null ? json['pengguna']['peran'] : 'petani',
      pesan: json['pesan'],
      foto: json['foto'],
      createdAt: json['created_at'],
    );
  }
}

class ModelKonsultasi {
  final int id;
  final int penggunaId;
  final String komoditas;
  final String judulKeluhan;
  final String deskripsiGejala;
  final String tingkatUrgensi;
  final String? fotoTanaman;
  final String? tanggapanAhli;
  final String status;
  final String createdAt;
  final String updatedAt;
  final List<ModelPesanKonsultasi> pesan;
  final bool isSurveiDiisi;

  ModelKonsultasi({
    required this.id,
    required this.penggunaId,
    required this.komoditas,
    required this.judulKeluhan,
    required this.deskripsiGejala,
    required this.tingkatUrgensi,
    this.fotoTanaman,
    this.tanggapanAhli,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.pesan = const [],
    this.isSurveiDiisi = false,
  });

  factory ModelKonsultasi.fromJson(Map<String, dynamic> json) {
    List<ModelPesanKonsultasi> listPesan = [];
    if (json['pesan'] != null) {
      listPesan = (json['pesan'] as List)
          .map((i) => ModelPesanKonsultasi.fromJson(i))
          .toList();
    }

    return ModelKonsultasi(
      id: json['id'],
      penggunaId: json['pengguna_id'],
      komoditas: json['komoditas'],
      judulKeluhan: json['judul_keluhan'],
      deskripsiGejala: json['deskripsi_gejala'],
      tingkatUrgensi: json['tingkat_urgensi'],
      fotoTanaman: json['foto_tanaman'],
      tanggapanAhli: json['tanggapan_ahli'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] ?? json['created_at'],
      pesan: listPesan,
      isSurveiDiisi: json['survei_kepuasan'] != null || json['surveiKepuasan'] != null,
    );
  }
}
