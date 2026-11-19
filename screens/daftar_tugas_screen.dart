import 'package:flutter/material.dart';

import '../models/tugas.dart';
import 'form_tugas_screen.dart';
import 'detail_tugas_screen.dart';

class DaftarTugasScreen extends StatefulWidget {
  const DaftarTugasScreen({super.key});

  @override
  State<DaftarTugasScreen> createState() => _DaftarTugasScreenState();
}

class _DaftarTugasScreenState extends State<DaftarTugasScreen> {
  final List<Tugas> _tugas = [
    Tugas(
      id: 'T001',
      judul: 'Membuat makalah sistem operasi',
      mataKuliah: 'Sistem Operasi',
      deskripsi: 'Menyusun makalah tentang manajemen proses dan memori.',
      tenggat: '25-11-2026',
      prioritas: 'Tinggi',
    ),
    Tugas(
      id: 'T002',
      judul: 'Praktik antarmuka Flutter',
      mataKuliah: 'Pemrograman Mobile',
      deskripsi:
          'Membuat tampilan aplikasi sederhana menggunakan widget Flutter.',
      tenggat: '28-11-2026',
      prioritas: 'Sedang',
    ),
    Tugas(
      id: 'T003',
      judul: 'Rangkuman jaringan komputer',
      mataKuliah: 'Jaringan Komputer',
      deskripsi: 'Merangkum materi model OSI dan protokol jaringan.',
      tenggat: '02-12-2026',
      prioritas: 'Rendah',
    ),
  ];

  int get _selesai => _tugas.where((e) => e.selesai).length;
  int get _belum => _tugas.length - _selesai;

  Color _warna(String p) {
    if (p == 'Tinggi') return const Color(0xFFD94B4B);
    if (p == 'Sedang') return const Color(0xFFCB8A19);
    return const Color(0xFF27845B);
  }

  Future<void> _tambah() async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(builder: (_) => const FormTugasScreen()),
    );
    if (!mounted || hasil == null) return;
    setState(() => _tugas.add(hasil));
    _pesan('Tugas berhasil ditambahkan.');
  }

  Future<void> _detail(Tugas item) async {
    final hasil = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(builder: (_) => DetailTugasScreen(tugas: item)),
    );
    if (!mounted) return;
    if (hasil is Tugas) {
      final i = _tugas.indexWhere((e) => e.id == hasil.id);
      if (i != -1) setState(() => _tugas[i] = hasil);
      _pesan('Tugas berhasil diperbarui.');
    } else if (hasil == 'deleted') {
      setState(() => _tugas.removeWhere((e) => e.id == item.id));
      _pesan('Tugas berhasil dihapus.');
    }
  }

  void _pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(teks)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TugasKu',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _tambah,
            icon: const Icon(Icons.add_circle_outline, size: 28),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Atur tugas kuliahmu dengan lebih mudah.',
                    style: TextStyle(color: Colors.blueGrey.shade600),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _Ringkasan(
                        label: 'Total',
                        angka: _tugas.length,
                        ikon: Icons.assignment_outlined,
                        warna: const Color(0xFF2457C5),
                      ),
                      const SizedBox(width: 9),
                      _Ringkasan(
                        label: 'Selesai',
                        angka: _selesai,
                        ikon: Icons.check_circle_outline,
                        warna: const Color(0xFF27845B),
                      ),
                      const SizedBox(width: 9),
                      _Ringkasan(
                        label: 'Belum',
                        angka: _belum,
                        ikon: Icons.pending_actions,
                        warna: const Color(0xFFCB8A19),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Tugas',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${_tugas.length} tugas',
                    style: TextStyle(color: Colors.blueGrey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _tugas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.blueGrey.shade300,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Belum ada tugas',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Tekan tombol tambah untuk mencatat tugas baru.',
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 2, 20, 100),
                      itemCount: _tugas.length,
                      itemBuilder: (context, index) {
                        final item = _tugas[index];
                        final warna = _warna(item.prioritas);
                        return Card(
                          elevation: 0,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                            side: const BorderSide(color: Color(0xFFE8ECF3)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(13),
                            leading: CircleAvatar(
                              backgroundColor: warna.withOpacity(.12),
                              child: Icon(
                                item.selesai
                                    ? Icons.check
                                    : Icons.assignment_outlined,
                                color: warna,
                              ),
                            ),
                            title: Text(
                              item.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.mataKuliah),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 5,
                                    children: [
                                      _ChipMini(
                                        'Tenggat ${item.tenggat}',
                                        const Color(0xFF52627A),
                                      ),
                                      _ChipMini(item.prioritas, warna),
                                      _ChipMini(
                                        item.selesai
                                            ? 'Selesai'
                                            : 'Belum selesai',
                                        item.selesai
                                            ? const Color(0xFF27845B)
                                            : const Color(0xFFCB8A19),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _detail(item),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ringkasan extends StatelessWidget {
  final String label;
  final int angka;
  final IconData ikon;
  final Color warna;
  const _Ringkasan({
    required this.label,
    required this.angka,
    required this.ikon,
    required this.warna,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(ikon, color: warna, size: 21),
          const SizedBox(height: 8),
          Text(
            '$angka',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600),
          ),
        ],
      ),
    ),
  );
}

class _ChipMini extends StatelessWidget {
  final String teks;
  final Color warna;
  const _ChipMini(this.teks, this.warna);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: warna.withOpacity(.10),
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      teks,
      style: TextStyle(color: warna, fontSize: 10, fontWeight: FontWeight.w600),
    ),
  );
}
