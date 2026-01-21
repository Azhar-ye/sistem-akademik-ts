import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/nilai_service.dart';
import '../services/user_service.dart';
import '../widgets/app_drawer.dart';
import 'add_nilai_screen.dart';
import 'edit_nilai_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nilaiService = NilaiService();
  final userService = UserService();

  String role = "user";
  String searchText = "";
  String filterMatkul = "Semua";

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
      appBar: AppBar(title: const Text("Data Nilai Mahasiswa")),
      drawer: AppDrawer(role: role),
      floatingActionButton: role == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddNilaiScreen()),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: Column(
        children: [
          // SEARCH
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search NIM / Nama...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => searchText = val.toLowerCase()),
            ),
          ),

          // FILTER MATKUL DARI FIRESTORE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
              stream: db.collection("matkul").snapshots(),
              builder: (context, snapshot) {
                List<String> items = ["Semua"];

                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  for (var d in docs) {
                    final nama = (d.data()["nama"] ?? "").toString();
                    if (nama.isNotEmpty) items.add(nama);
                  }
                }

                // pastikan filterMatkul valid
                if (!items.contains(filterMatkul)) {
                  filterMatkul = "Semua";
                }

                return DropdownButtonFormField<String>(
                  value: filterMatkul,
                  items: items
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (val) => setState(() => filterMatkul = val ?? "Semua"),
                  decoration: const InputDecoration(
                    labelText: "Filter Mata Kuliah",
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // LIST NILAI
          Expanded(
            child: StreamBuilder(
              stream: nilaiService.streamNilai(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final filtered = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  final nama = (data["nama"] ?? "").toString().toLowerCase();
                  final nim = (data["nim"] ?? "").toString().toLowerCase();
                  final matkul = (data["matkul"] ?? "").toString();

                  final matchSearch =
                      nama.contains(searchText) || nim.contains(searchText);

                  final matchMatkul =
                      filterMatkul == "Semua" || matkul == filterMatkul;

                  return matchSearch && matchMatkul;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final doc = filtered[i];
                    final data = doc.data() as Map<String, dynamic>;
                    final id = doc.id;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text("${data["nama"]} (${data["nim"]})"),
                        subtitle: Text("${data["matkul"]} | Nilai: ${data["nilai"]}"),
                        trailing: role == "admin"
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditNilaiScreen(
                                            id: id,
                                            nama: data["nama"],
                                            nim: data["nim"],
                                            matkul: data["matkul"],
                                            nilai: data["nilai"],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await nilaiService.deleteNilai(id);
                                    },
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
