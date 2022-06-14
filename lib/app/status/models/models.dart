class DataStatus {
  final String id;
  final String nama;
  final String tipe;
  final String judul;
  final String detail;
  final String tanggal;
  final String img;

  DataStatus({
    required this.id,
    required this.nama,
    required this.tipe,
    required this.judul,
    required this.detail,
    required this.tanggal,
    required this.img,
  });

  factory DataStatus.fromJson(Map<String, dynamic> json) {
    return DataStatus(
      id: json['id'].toString(),
      nama: json['nama'].toString(),
      tipe: json['tipe'].toString(),
      judul: json['judul'].toString(),
      detail: json['detail'].toString(),
      tanggal: json["tanggal"].toString(),
      img: json['img'].toString(),
    );
  }
}
