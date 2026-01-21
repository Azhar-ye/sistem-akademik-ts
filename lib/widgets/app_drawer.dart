import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/dashboard_screen.dart';
import '../screens/home_screen.dart';
import '../screens/matkul_screen.dart';
import '../screens/rekap_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final String role;
  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.school, color: Colors.white, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    "Sistem Akademik\n($role)",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text("Data Nilai"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Rekap Nilai"),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RekapScreen()),
              );
            },
          ),

          if (role == "admin")
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text("Data Mata Kuliah"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MatkulScreen()),
                );
              },
            ),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              await auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
