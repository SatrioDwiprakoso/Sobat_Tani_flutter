class ModelCuaca {
  final String kota;
  final int suhu;
  final String kondisi;
  final String kelembaban;
  final String angin;

  ModelCuaca({
    required this.kota,
    required this.suhu,
    required this.kondisi,
    required this.kelembaban,
    required this.angin,
  });

  factory ModelCuaca.fromJson(Map<String, dynamic> json) {
    return ModelCuaca(
      kota: json['kota'],
      suhu: json['suhu'],
      kondisi: json['kondisi'],
      kelembaban: json['kelembaban'],
      angin: json['angin'],
    );
  }
}
