class ModelPengguna {
  final int id;
  final String namaLengkap;
  final String email;
  final String? nomorTelepon;
  final String? fotoProfil;
  final String peran;

  ModelPengguna({
    required this.id,
    required this.namaLengkap,
    required this.email,
    this.nomorTelepon,
    this.fotoProfil,
    required this.peran,
  });

  factory ModelPengguna.fromJson(Map<String, dynamic> json) {
    return ModelPengguna(
      id: json['id'],
      namaLengkap: json['nama_lengkap'],
      email: json['email'],
      nomorTelepon: json['nomor_telepon'],
      fotoProfil: json['foto_profil'],
      peran: json['peran'],
    );
  }
}
