import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';
import '../widgets/app_drawer.dart';

class RekapScreen extends StatefulWidget {
  const RekapScreen({super.key});

  @override
  State<RekapScreen> createState() => _RekapScreenState();
}

class _RekapScreenState extends State<RekapScreen> {
  final userService = UserService();
  String role = "user";

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final r = await userService.getRole();
    setState(() => role = r);
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Rekap Nilai")),
      drawer: AppDrawer(role: role),
      body: StreamBuilder(
        stream: db.collection("nilai").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final Map<String, List<int>> mapNilai = {};

          for (var d in docs) {
            final data = d.data();
            final matkul = (data["matkul"] ?? "").toString();
            final nilai = (data["nilai"] ?? 0) as int;

            if (matkul.isEmpty) continue;

            mapNilai.putIfAbsent(matkul, () => []);
            mapNilai[matkul]!.add(nilai);
          }

          if (mapNilai.isEmpty) {
            return const Center(child: Text("Belum ada data nilai"));
          }

          final entries = mapNilai.entries.toList();

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, i) {
              final matkul = entries[i].key;
              final nilaiList = entries[i].value;

              final total = nilaiList.reduce((a, b) => a + b);
              final avg = total / nilaiList.length;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(matkul),
                  subtitle: Text("Jumlah data: ${nilaiList.length}"),
                  trailing: Text(
                    avg.toStringAsFixed(1),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
