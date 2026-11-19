import 'package:flutter/material.dart';

import '../models/tugas.dart';

class FormTugasScreen extends StatefulWidget {
  final Tugas? tugas;
  const FormTugasScreen({super.key, this.tugas});

  @override
  State<FormTugasScreen> createState() => _FormTugasScreenState();
}

class _FormTugasScreenState extends State<FormTugasScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  late final TextEditingController _deskripsi;
  late final TextEditingController _tenggat;
  String? _prioritas;
  bool _selesai = false;

  bool get _modeEdit => widget.tugas != null;

  @override
  void initState() {
    super.initState();
    final data = widget.tugas;
    _judul = TextEditingController(text: data?.judul ?? '');
    _mataKuliah = TextEditingController(text: data?.mataKuliah ?? '');
    _deskripsi = TextEditingController(text: data?.deskripsi ?? '');
    _tenggat = TextEditingController(text: data?.tenggat ?? '');
    _prioritas = data?.prioritas;
    _selesai = data?.selesai ?? false;
  }

  @override
  void dispose() {
    _judul.dispose();
    _mataKuliah.dispose();
    _deskripsi.dispose();
    _tenggat.dispose();
    super.dispose();
  }

  String? _validasiTanggal(String? nilai) {
    if (nilai == null || nilai.trim().isEmpty) return 'Tenggat wajib diisi.';
    final pola = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$');
    final cocok = pola.firstMatch(nilai.trim());
    if (cocok == null) return 'Gunakan format DD-MM-YYYY.';
    final hari = int.parse(cocok.group(1)!);
    final bulan = int.parse(cocok.group(2)!);
    final tahun = int.parse(cocok.group(3)!);
    final tanggal = DateTime(tahun, bulan, hari);
    if (tanggal.year != tahun ||
        tanggal.month != bulan ||
        tanggal.day != hari) {
      return 'Tanggal tidak valid.';
    }
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    if (_prioritas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih prioritas tugas.')),
      );
      return;
    }
    final hasil = Tugas(
      id: widget.tugas?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      judul: _judul.text.trim(),
      mataKuliah: _mataKuliah.text.trim(),
      deskripsi: _deskripsi.text.trim(),
      tenggat: _tenggat.text.trim(),
      prioritas: _prioritas!,
      selesai: _selesai,
    );
    Navigator.pop(context, hasil);
  }

  Widget _judulField(String teks) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(teks, style: const TextStyle(fontWeight: FontWeight.w700)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _modeEdit ? 'Ubah Tugas' : 'Tambah Tugas',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
          children: [
            Text(
              _modeEdit
                  ? 'Perbarui informasi tugasmu.'
                  : 'Catat tugas kuliah yang baru.',
              style: TextStyle(color: Colors.blueGrey.shade600),
            ),
            const SizedBox(height: 22),
            _judulField('Judul Tugas'),
            TextFormField(
              controller: _judul,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Contoh: Membuat makalah',
                prefixIcon: Icon(Icons.edit_note),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Judul tugas wajib diisi.';
                if (v.trim().length < 3) return 'Judul minimal 3 karakter.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _judulField('Mata Kuliah'),
            TextFormField(
              controller: _mataKuliah,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Contoh: Pemrograman Mobile',
                prefixIcon: Icon(Icons.school_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Mata kuliah wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 16),
            _judulField('Deskripsi'),
            TextFormField(
              controller: _deskripsi,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Jelaskan tugas yang harus dikerjakan...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Deskripsi wajib diisi.';
                if (v.trim().length < 10)
                  return 'Deskripsi minimal 10 karakter.';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _judulField('Tenggat (DD-MM-YYYY)'),
            TextFormField(
              controller: _tenggat,
              keyboardType: TextInputType.datetime,
              decoration: const InputDecoration(
                hintText: '25-11-2026',
                prefixIcon: Icon(Icons.calendar_month_outlined),
              ),
              validator: _validasiTanggal,
            ),
            const SizedBox(height: 16),
            _judulField('Prioritas'),
            DropdownButtonFormField<String>(
              value: _prioritas,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.flag_outlined),
              ),
              hint: const Text('Pilih prioritas'),
              items: const [
                DropdownMenuItem(value: 'Rendah', child: Text('Rendah')),
                DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                DropdownMenuItem(value: 'Tinggi', child: Text('Tinggi')),
              ],
              onChanged: (v) => setState(() => _prioritas = v),
            ),
            if (_modeEdit) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE1E6F0)),
                ),
                child: CheckboxListTile(
                  value: _selesai,
                  onChanged: (v) => setState(() => _selesai = v ?? false),
                  title: const Text('Tugas sudah selesai'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
            const SizedBox(height: 26),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save_outlined),
                label: Text(_modeEdit ? 'Simpan Perubahan' : 'Simpan Tugas'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
