class Tugas {
  final String id;
  String judul;
  String mataKuliah;
  String deskripsi;
  String tenggat;
  String prioritas;
  bool selesai;

  Tugas({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.deskripsi,
    required this.tenggat,
    required this.prioritas,
    this.selesai = false,
  });
}
