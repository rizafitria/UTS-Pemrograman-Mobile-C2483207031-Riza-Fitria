import 'package:flutter/material.dart';

import 'screens/daftar_tugas_screen.dart';

void main() => runApp(const TugasKuApp());

class TugasKuApp extends StatelessWidget {
  const TugasKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const biru = Color(0xFF2457C5);
    return MaterialApp(
      title: 'TugasKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: biru),
        scaffoldBackgroundColor: const Color(0xFFF7F8FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F8FC),
          foregroundColor: Color(0xFF17233D),
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E6F0)),
          ),
        ),
      ),
      home: const DaftarTugasScreen(),
    );
  }
}
