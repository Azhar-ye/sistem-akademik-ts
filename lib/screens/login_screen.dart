import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  final auth = AuthService();
  final userService = UserService();

  bool isLogin = true;
  bool loading = false;

  Future<void> submit() async {
    setState(() => loading = true);

    try {
      if (isLogin) {
        await auth.login(emailC.text.trim(), passC.text.trim());
      } else {
        await auth.register(emailC.text.trim(), passC.text.trim());
      }

      await userService.createUserIfNotExists();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(Icons.school, size: 80),
                    const SizedBox(height: 10),
                    const Text(
                      "Sistem Akademik",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),

                    TextField(
                      controller: emailC,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: loading ? null : submit,
                        child: Text(
                          loading
                              ? "Loading..."
                              : (isLogin ? "Login" : "Register"),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        isLogin
                            ? "Belum punya akun? Register"
                            : "Sudah punya akun? Login",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
