class TenagaKesehatan {
  String id;
  String nama;
  String noTelp;
  String email;
  String alamat;
  String userId;

  TenagaKesehatan({
    required this.id,
    required this.nama,
    required this.noTelp,
    required this.email,
    required this.alamat,
    required this.userId,
  });

  factory TenagaKesehatan.fromMap(Map<String, dynamic> data, String id) {
    return TenagaKesehatan(
      id: id,
      nama: data['nama'],
      noTelp: data['no_telp'],
      email: data['email'],
      alamat: data['alamat'],
      userId: data['userId'],
    );
  }
}