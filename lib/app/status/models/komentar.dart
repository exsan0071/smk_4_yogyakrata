class DataKomen {
  final String id;
  final String nama;
  final String isi;
  final String tanggal;
  final String source;
  final String img;

  DataKomen({
    required this.id,
    required this.nama,
    required this.isi,
    required this.tanggal,
    required this.source,
    required this.img,
  });

  factory DataKomen.fromJson(Map<String, dynamic> json) {
    return DataKomen(
      id: json['komentar_id'].toString(),
      nama: json['komentar_nama'].toString(),
      isi: json['komentar_isi'].toString(),
      tanggal: json['komentar_tanggal'].toString(),
      source: json['source'].toString(),
      img: json['photo'].toString(),
    );
  }
}
