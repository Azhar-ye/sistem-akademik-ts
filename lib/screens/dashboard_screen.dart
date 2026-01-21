import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_service.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      appBar: AppBar(title: const Text("Dashboard Akademik")),
      drawer: AppDrawer(role: role),
      body: StreamBuilder(
        stream: db.collection("nilai").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          final Set<String> mahasiswaUnik = {};
          int totalNilai = 0;

          for (var d in docs) {
            final data = d.data();
            final nim = (data["nim"] ?? "").toString();
            final nilai = (data["nilai"] ?? 0) as int;

            if (nim.isNotEmpty) mahasiswaUnik.add(nim);
            totalNilai += nilai;
          }

          final totalMahasiswa = mahasiswaUnik.length;
          final totalDataNilai = docs.length;
          final rataRata = totalDataNilai == 0 ? 0 : totalNilai / totalDataNilai;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.people, size: 34),
                              const SizedBox(height: 8),
                              const Text("Total Mahasiswa"),
                              const SizedBox(height: 8),
                              Text(
                                "$totalMahasiswa",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.assignment, size: 34),
                              const SizedBox(height: 8),
                              const Text("Total Data Nilai"),
                              const SizedBox(height: 8),
                              Text(
                                "$totalDataNilai",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 34),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Rata-rata Nilai Keseluruhan"),
                              const SizedBox(height: 6),
                              Text(
                                rataRata.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.calculate, size: 34),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Nilai (Akumulasi)"),
                              const SizedBox(height: 6),
                              Text(
                                "$totalNilai",
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Statistik dihitung real-time dari Firestore",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
