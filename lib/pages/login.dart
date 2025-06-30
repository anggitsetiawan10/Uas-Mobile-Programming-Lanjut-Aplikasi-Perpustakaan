import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'user_home.dart';
import 'forgot.dart';
import 'dashboard.dart'; // ✅ Import halaman admin

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void _login() async {
    String id = idController.text.trim();
    String password = passwordController.text.trim();

    print("🔵 Tombol login ditekan");
    print("🟡 ID: $id, Password: $password");

    if (id.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ID dan kata sandi wajib diisi")),
      );
      print("❗ ID atau password kosong");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final auth = AuthService();
    final result = await auth.login(id, password);

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      final user = result['user'] as User;
      print("✅ Login berhasil sebagai ${user.role}");

      if (user.role == 'admin') {
        print("🔐 Navigasi ke halaman admin...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage()),
        );
      } else if (user.role == 'anggota') {
        print("👤 Navigasi ke halaman anggota...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❗ Role tidak dikenali")),
        );
      }
    } else {
      print("❌ Login gagal: ${result['message']}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Gagal login')),
      );
    }
  }

  void _forgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(Icons.local_library, size: 80, color: Colors.indigo),
            const SizedBox(height: 10),
            const Text(
              "Perpustakaan Online",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: "Email Anggota",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "Kata Sandi",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Masuk"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _forgotPassword,
              child: const Text(
                "Lupa Kata Sandi?",
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import '../services/auth_service.dart';
// import '../models/user_model.dart';
// import 'user_home.dart';
// import 'forgot.dart';
//
// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController idController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscureText = true;
//   bool _isLoading = false;
//
//   void _login() async {
//     String id = idController.text.trim();
//     String password = passwordController.text.trim();
//
//     print("🔵 Tombol login ditekan");
//     print("🟡 ID: $id, Password: $password");
//
//     if (id.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("ID dan kata sandi wajib diisi")),
//       );
//       print("❗ ID atau password kosong");
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//     });
//
//     final auth = AuthService();
//     final result = await auth.login(id, password);
//
//     setState(() {
//       _isLoading = false;
//     });
//
//     if (result['success']) {
//       final user = result['user'] as User;
//       print("✅ Login berhasil sebagai ${user.role}");
//
//       if (user.role == 'admin') {
//         print("🔐 Navigasi ke halaman admin...");
//         // TODO: Navigasi ke halaman admin di sini
//       } else {
//         print("👤 Navigasi ke halaman anggota...");
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => UserHomePage()),
//         );
//       }
//     } else {
//       print("❌ Login gagal: ${result['message']}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? 'Gagal login')),
//       );
//     }
//   }
//
//   void _forgotPassword() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => ForgotPasswordPage(),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
//         child: Column(
//           children: [
//             SizedBox(height: 40),
//             Icon(Icons.local_library, size: 80, color: Colors.indigo),
//             SizedBox(height: 10),
//             Text(
//               "Perpustakaan Online",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             SizedBox(height: 40),
//             TextField(
//               controller: idController,
//               decoration: InputDecoration(
//                 labelText: "Email Anggota",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               obscureText: _obscureText,
//               decoration: InputDecoration(
//                 labelText: "Kata Sandi",
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscureText
//                         ? Icons.visibility_off
//                         : Icons.visibility,
//                   ),
//                   onPressed: () =>
//                       setState(() => _obscureText = !_obscureText),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//               onPressed: _login,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text("Masuk"),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: _forgotPassword,
//               child: Text(
//                 "Lupa Kata Sandi?",
//                 style: TextStyle(color: Colors.indigo),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
