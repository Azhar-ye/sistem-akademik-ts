import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/nilai_service.dart';

class AddNilaiScreen extends StatefulWidget {
  const AddNilaiScreen({super.key});

  @override
  State<AddNilaiScreen> createState() => _AddNilaiScreenState();
}

class _AddNilaiScreenState extends State<AddNilaiScreen> {
  final namaC = TextEditingController();
  final nimC = TextEditingController();
  final nilaiC = TextEditingController();

  String? selectedMatkul;
  final service = NilaiService();

  Future<void> save() async {
    if (namaC.text.trim().isEmpty ||
        nimC.text.trim().isEmpty ||
        nilaiC.text.trim().isEmpty ||
        selectedMatkul == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi!")),
      );
      return;
    }

    final nilaiInt = int.tryParse(nilaiC.text.trim());
    if (nilaiInt == null || nilaiInt < 0 || nilaiInt > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai harus angka 0 - 100")),
      );
      return;
    }

    await service.addNilai(
      nama: namaC.text.trim(),
      nim: nimC.text.trim(),
      matkul: selectedMatkul!,
      nilai: nilaiInt,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Nilai")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: namaC,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nimC,
                  decoration: const InputDecoration(labelText: "NIM"),
                ),
                const SizedBox(height: 10),

                StreamBuilder(
                  stream: db.collection("matkul").snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const LinearProgressIndicator();
                    }

                    final docs = snapshot.data!.docs;
                    final matkulItems = docs
                        .map((d) => (d.data()["nama"] ?? "").toString())
                        .where((x) => x.isNotEmpty)
                        .toList();

                    if (matkulItems.isEmpty) {
                      return const Text(
                        "Belum ada data matkul.\nTambahkan dulu di menu Data Mata Kuliah.",
                        textAlign: TextAlign.center,
                      );
                    }

                    selectedMatkul ??= matkulItems.first;

                    return DropdownButtonFormField<String>(
                      value: selectedMatkul,
                      items: matkulItems
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (val) => setState(() => selectedMatkul = val),
                      decoration: const InputDecoration(labelText: "Mata Kuliah"),
                    );
                  },
                ),

                const SizedBox(height: 10),
                TextField(
                  controller: nilaiC,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Nilai (0-100)"),
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: save,
                    child: const Text("Simpan"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
