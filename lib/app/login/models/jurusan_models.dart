class DataJurusan {
  final String id;
  final String nama;
  final String status;

  DataJurusan({
    required this.id,
    required this.nama,
    required this.status,
  });

  factory DataJurusan.fromJson(Map<String, dynamic> json) {
    return DataJurusan(
      id: json['kode'].toString(),
      nama: json['nama'].toString(),
      status: json['jenjang'].toString(),
    );
  }
}
