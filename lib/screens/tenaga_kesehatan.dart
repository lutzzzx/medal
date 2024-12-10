import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TenagaKesehatanMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Tenaga Kesehatan & Jadwal Kunjungan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Tenaga Kesehatan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daftar Tenaga Kesehatan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('tenaga_kesehatan')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Belum ada data tenaga kesehatan.'));
                }
                final tenagaKesehatan = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tenagaKesehatan.length,
                  itemBuilder: (context, index) {
                    final data = tenagaKesehatan[index];
                    return ListTile(
                      title: Text(data['nama']),
                      subtitle: Text(data['no_telp']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailTenagaKesehatanPage(
                              tenagaKesehatanId: data.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            Divider(),
            // Bagian Jadwal Kunjungan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Daftar Jadwal Kunjungan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('jadwal_kunjungan')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('Belum ada jadwal kunjungan.'));
                }
                final jadwalKunjungan = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: jadwalKunjungan.length,
                  itemBuilder: (context, index) {
                    final data = jadwalKunjungan[index];
                    return ListTile(
                      title: Text(data['nama_ahli_kesehatan']),
                      subtitle: Text('${data['tanggal']} - ${data['jam']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailJadwalKunjunganPage(
                              jadwalKunjunganId: data.id,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Tambah Tenaga Kesehatan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahTenagaKesehatanPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Tambah Jadwal Kunjungan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TambahJadwalKunjunganPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TambahTenagaKesehatanPage extends StatefulWidget {
  @override
  _TambahTenagaKesehatanPageState createState() => _TambahTenagaKesehatanPageState();
}

class _TambahTenagaKesehatanPageState extends State<TambahTenagaKesehatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  void _tambahData() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('tenaga_kesehatan').add({
        'nama': _namaController.text,
        'no_telp': _noTelpController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
        'userId': userId,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tenaga Kesehatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                validator: (value) => value!.isEmpty ? 'No Telepon harus diisi' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email harus diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Alamat harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahData,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailTenagaKesehatanPage extends StatelessWidget {
  final String tenagaKesehatanId;

  DetailTenagaKesehatanPage({required this.tenagaKesehatanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tenaga Kesehatan'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('tenaga_kesehatan')
            .doc(tenagaKesehatanId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Data tidak ditemukan'));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama: ${data['nama']}', style: TextStyle(fontSize: 18)),
                Text('No Telepon: ${data['no_telp']}', style: TextStyle(fontSize: 18)),
                Text('Email: ${data['email']}', style: TextStyle(fontSize: 18)),
                Text('Alamat: ${data['alamat']}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTenagaKesehatanPage(
                              tenagaKesehatanId: tenagaKesehatanId,
                            ),
                          ),
                        );
                      },
                      child: Text('Edit'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Hapus Tenaga Kesehatan'),
                            content: Text('Apakah Anda yakin ingin menghapus data ini?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await FirebaseFirestore.instance
                              .collection('tenaga_kesehatan')
                              .doc(tenagaKesehatanId)
                              .delete();
                          Navigator.pop(context);
                        }
                      },
                      child: Text('Hapus'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditTenagaKesehatanPage extends StatefulWidget {
  final String tenagaKesehatanId;

  EditTenagaKesehatanPage({required this.tenagaKesehatanId});

  @override
  _EditTenagaKesehatanPageState createState() => _EditTenagaKesehatanPageState();
}

class _EditTenagaKesehatanPageState extends State<EditTenagaKesehatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await FirebaseFirestore.instance
        .collection('tenaga_kesehatan')
        .doc(widget.tenagaKesehatanId)
        .get();
    _namaController.text = data['nama'];
    _noTelpController.text = data['no_telp'];
    _emailController.text = data['email'];
    _alamatController.text = data['alamat'];
  }

  void _updateData() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('tenaga_kesehatan')
          .doc(widget.tenagaKesehatanId)
          .update({
        'nama': _namaController.text,
        'no_telp': _noTelpController.text,
        'email': _emailController.text,
        'alamat': _alamatController.text,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tenaga Kesehatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
              ),
              TextFormField(
                controller: _noTelpController,
                decoration: InputDecoration(labelText: 'No Telepon'),
                validator: (value) => value!.isEmpty ? 'No Telepon harus diisi' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Email harus diisi' : null,
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) => value!.isEmpty ? 'Alamat harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateData,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TambahJadwalKunjunganPage extends StatefulWidget {
  @override
  _TambahJadwalKunjunganPageState createState() => _TambahJadwalKunjunganPageState();
}

class _TambahJadwalKunjunganPageState extends State<TambahJadwalKunjunganPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaAhliKesehatanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _selectedTenagaKesehatanId;
  List<DocumentSnapshot> _tenagaKesehatanList = [];

  @override
  void initState() {
    super.initState();
    _loadTenagaKesehatan();
  }

  void _loadTenagaKesehatan() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('tenaga_kesehatan')
        .where('userId', isEqualTo: userId)
        .get();
    setState(() {
      _tenagaKesehatanList = snapshot.docs;
    });
  }

  void _selectTanggal() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _tanggalController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _selectJam() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _jamController.text =
        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  void _tambahJadwal() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('jadwal_kunjungan').add({
        'nama_ahli_kesehatan': _selectedTenagaKesehatanId == null
            ? _namaAhliKesehatanController.text
            : _tenagaKesehatanList
            .firstWhere((doc) => doc.id == _selectedTenagaKesehatanId)['nama'],
        'tanggal': _tanggalController.text,
        'jam': _jamController.text,
        'keterangan': _keteranganController.text,
        'userId': userId,
        'tenagaKesehatanId': _selectedTenagaKesehatanId,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Jadwal Kunjungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                items: _tenagaKesehatanList
                    .map(
                      (doc) => DropdownMenuItem(
                    value: doc.id,
                    child: Text(doc['nama']),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTenagaKesehatanId = value as String?;
                  });
                },
                decoration: InputDecoration(labelText: 'Pilih Tenaga Kesehatan'),
              ),
              if (_selectedTenagaKesehatanId == null)
                TextFormField(
                  controller: _namaAhliKesehatanController,
                  decoration: InputDecoration(labelText: 'Nama Ahli Kesehatan'),
                  validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                ),
              InkWell(
                onTap: _selectTanggal,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _tanggalController,
                    decoration: InputDecoration(labelText: 'Tanggal'),
                    validator: (value) => value!.isEmpty ? 'Tanggal harus diisi' : null,
                  ),
                ),
              ),
              InkWell(
                onTap: _selectJam,
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _jamController,
                    decoration: InputDecoration(labelText: 'Jam'),
                    validator: (value) => value!.isEmpty ? 'Jam harus diisi' : null,
                  ),
                ),
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) => value!.isEmpty ? 'Keterangan harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _tambahJadwal,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailJadwalKunjunganPage extends StatelessWidget {
  final String jadwalKunjunganId;

  DetailJadwalKunjunganPage({required this.jadwalKunjunganId});

  void _hapusJadwal(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Jadwal'),
        content: Text('Apakah Anda yakin ingin menghapus jadwal ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('jadwal_kunjungan')
          .doc(jadwalKunjunganId)
          .delete();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Jadwal Kunjungan'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditJadwalKunjunganPage(
                    jadwalKunjunganId: jadwalKunjunganId,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _hapusJadwal(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('jadwal_kunjungan')
            .doc(jadwalKunjunganId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Data tidak ditemukan'));
          }
          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Ahli Kesehatan: ${data['nama_ahli_kesehatan']}',
                    style: TextStyle(fontSize: 18)),
                Text('Tanggal: ${data['tanggal']}',
                    style: TextStyle(fontSize: 18)),
                Text('Jam: ${data['jam']}', style: TextStyle(fontSize: 18)),
                Text('Keterangan: ${data['keterangan']}',
                    style: TextStyle(fontSize: 18)),
                if (data['tenagaKesehatanId'] != null)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailTenagaKesehatanPage(
                            tenagaKesehatanId: data['tenagaKesehatanId'],
                          ),
                        ),
                      );
                    },
                    child: Text('Lihat Detail Tenaga Kesehatan'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EditJadwalKunjunganPage extends StatefulWidget {
  final String jadwalKunjunganId;

  EditJadwalKunjunganPage({required this.jadwalKunjunganId});

  @override
  _EditJadwalKunjunganPageState createState() =>
      _EditJadwalKunjunganPageState();
}

class _EditJadwalKunjunganPageState extends State<EditJadwalKunjunganPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaAhliKesehatanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _jamController = TextEditingController();
  final _keteranganController = TextEditingController();
  String? _selectedTenagaKesehatanId;
  List<DocumentSnapshot> _tenagaKesehatanList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('jadwal_kunjungan')
        .doc(widget.jadwalKunjunganId)
        .get();
    final tenagaKesehatanSnapshot = await FirebaseFirestore.instance
        .collection('tenaga_kesehatan')
        .get();

    setState(() {
      _namaAhliKesehatanController.text = snapshot['nama_ahli_kesehatan'];
      _tanggalController.text = snapshot['tanggal'];
      _jamController.text = snapshot['jam'];
      _keteranganController.text = snapshot['keterangan'];
      _selectedTenagaKesehatanId = snapshot['tenagaKesehatanId'];
      _tenagaKesehatanList = tenagaKesehatanSnapshot.docs;
    });
  }

  void _editJadwal() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection('jadwal_kunjungan')
          .doc(widget.jadwalKunjunganId)
          .update({
        'nama_ahli_kesehatan': _selectedTenagaKesehatanId == null
            ? _namaAhliKesehatanController.text
            : _tenagaKesehatanList
            .firstWhere((doc) => doc.id == _selectedTenagaKesehatanId)['nama'],
        'tanggal': _tanggalController.text,
        'jam': _jamController.text,
        'keterangan': _keteranganController.text,
        'tenagaKesehatanId': _selectedTenagaKesehatanId,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Jadwal Kunjungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField(
                items: _tenagaKesehatanList
                    .map(
                      (doc) => DropdownMenuItem(
                    value: doc.id,
                    child: Text(doc['nama']),
                  ),
                )
                    .toList(),
                value: _selectedTenagaKesehatanId,
                onChanged: (value) {
                  setState(() {
                    _selectedTenagaKesehatanId = value as String?;
                  });
                },
                decoration: InputDecoration(labelText: 'Pilih Tenaga Kesehatan'),
              ),
              if (_selectedTenagaKesehatanId == null)
                TextFormField(
                  controller: _namaAhliKesehatanController,
                  decoration: InputDecoration(labelText: 'Nama Ahli Kesehatan'),
                  validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                ),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_tanggalController.text),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    _tanggalController.text =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _tanggalController,
                    decoration: InputDecoration(labelText: 'Tanggal'),
                    validator: (value) => value!.isEmpty ? 'Tanggal harus diisi' : null,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      DateTime.parse("2023-01-01 ${_jamController.text}:00"),
                    ),
                  );
                  if (pickedTime != null) {
                    _jamController.text =
                    "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: _jamController,
                    decoration: InputDecoration(labelText: 'Jam'),
                    validator: (value) => value!.isEmpty ? 'Jam harus diisi' : null,
                  ),
                ),
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) => value!.isEmpty ? 'Keterangan harus diisi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editJadwal,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

