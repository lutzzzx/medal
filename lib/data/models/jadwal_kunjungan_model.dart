class JadwalKunjungan {
  String id;
  String namaAhliKesehatan;
  String tanggal;
  String jam;
  String keterangan;
  String userId;
  String? tenagaKesehatanId;

  JadwalKunjungan({
    required this.id,
    required this.namaAhliKesehatan,
    required this.tanggal,
    required this.jam,
    required this.keterangan,
    required this.userId,
    this.tenagaKesehatanId,
  });

  factory JadwalKunjungan.fromMap(Map<String, dynamic> data, String id) {
    return JadwalKunjungan(
      id: id,
      namaAhliKesehatan: data['nama_ahli_kesehatan'],
      tanggal: data['tanggal'],
      jam: data['jam'],
      keterangan: data['keterangan'],
      userId: data['userId'],
      tenagaKesehatanId: data['tenagaKesehatanId'],
    );
  }
}