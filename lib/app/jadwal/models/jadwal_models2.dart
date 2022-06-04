class DataJadwal {
  final String jmMulai;
  final String jmSelesai;
  final String namaPelajaran;
  final String namaGuru;

  DataJadwal({
    required this.jmMulai,
    required this.jmSelesai,
    required this.namaPelajaran,
    required this.namaGuru,
  });

  factory DataJadwal.fromJson(Map<String, dynamic> json) {
    return DataJadwal(
      jmMulai: json['jam_mulai'].toString(),
      jmSelesai: json['jam_selesai'].toString(),
      namaPelajaran: json['nama_pelajaran'].toString(),
      namaGuru: json['nama_guru'].toString(),
    );
  }
}
