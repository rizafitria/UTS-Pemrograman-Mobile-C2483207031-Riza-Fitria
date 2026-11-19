import 'package:flutter/material.dart';

import '../models/tugas.dart';
import 'form_tugas_screen.dart';

class DetailTugasScreen extends StatelessWidget {
  final Tugas tugas;
  const DetailTugasScreen({super.key, required this.tugas});

  Future<void> _ubah(BuildContext context) async {
    final hasil = await Navigator.push<Tugas>(
      context,
      MaterialPageRoute(builder: (_) => FormTugasScreen(tugas: tugas)),
    );
    if (hasil != null && context.mounted) Navigator.pop(context, hasil);
  }

  Future<void> _hapus(BuildContext context) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content: Text('Yakin ingin menghapus "${tugas.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD94B4B),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (setuju == true && context.mounted) Navigator.pop(context, 'deleted');
  }

  Widget _baris(String label, String isi, IconData ikon, {Color? warna}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(ikon, color: warna ?? const Color(0xFF64748B), size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                isi,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: warna ?? const Color(0xFF17233D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final warna = tugas.prioritas == 'Tinggi'
        ? const Color(0xFFD94B4B)
        : tugas.prioritas == 'Sedang'
        ? const Color(0xFFCB8A19)
        : const Color(0xFF27845B);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Tugas',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2457C5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.assignment_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: 18),
                Text(
                  tugas.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  tugas.mataKuliah,
                  style: const TextStyle(color: Color(0xFFDCE7FF)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE8ECF3)),
            ),
            child: Column(
              children: [
                _baris('ID Tugas', tugas.id, Icons.tag),
                const Divider(height: 25),
                _baris('Mata Kuliah', tugas.mataKuliah, Icons.school_outlined),
                const Divider(height: 25),
                _baris(
                  'Deskripsi',
                  tugas.deskripsi,
                  Icons.description_outlined,
                ),
                const Divider(height: 25),
                _baris('Tenggat', tugas.tenggat, Icons.calendar_month_outlined),
                const Divider(height: 25),
                _baris(
                  'Prioritas',
                  tugas.prioritas,
                  Icons.flag_outlined,
                  warna: warna,
                ),
                const Divider(height: 25),
                _baris(
                  'Status',
                  tugas.selesai ? 'Selesai' : 'Belum selesai',
                  tugas.selesai
                      ? Icons.check_circle_outline
                      : Icons.pending_actions,
                  warna: tugas.selesai
                      ? const Color(0xFF27845B)
                      : const Color(0xFFCB8A19),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 51,
            child: FilledButton.icon(
              onPressed: () => _ubah(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Ubah Tugas'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 51,
            child: OutlinedButton.icon(
              onPressed: () => _hapus(context),
              icon: const Icon(Icons.delete_outline, color: Color(0xFFD94B4B)),
              label: const Text(
                'Hapus Tugas',
                style: TextStyle(color: Color(0xFFD94B4B)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFF0CACA)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
