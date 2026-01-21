import 'package:flutter/material.dart';
import '../services/matkul_service.dart';
import '../services/user_service.dart';
import '../widgets/app_drawer.dart';

class MatkulScreen extends StatefulWidget {
  const MatkulScreen({super.key});

  @override
  State<MatkulScreen> createState() => _MatkulScreenState();
}

class _MatkulScreenState extends State<MatkulScreen> {
  final service = MatkulService();
  final userService = UserService();

  String role = "user";
  final matkulC = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final r = await userService.getRole();
    setState(() => role = r);
  }

  Future<void> addMatkul() async {
    if (matkulC.text.trim().isEmpty) return;
    await service.addMatkul(matkulC.text.trim());
    matkulC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Mata Kuliah")),
      drawer: AppDrawer(role: role),
      body: Column(
        children: [
          if (role == "admin")
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: matkulC,
                      decoration: const InputDecoration(
                        labelText: "Tambah Mata Kuliah",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: addMatkul,
                    child: const Text("Tambah"),
                  )
                ],
              ),
            ),

          Expanded(
            child: StreamBuilder(
              stream: service.streamMatkul(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                if (docs.isEmpty) {
                  return const Center(child: Text("Belum ada mata kuliah"));
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final id = docs[i].id;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(data["nama"] ?? ""),
                        trailing: role == "admin"
                            ? IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await service.deleteMatkul(id);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
