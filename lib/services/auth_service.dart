import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../constans/api.dart';

class AuthService {
  // final String baseUrl = "http://10.0.2.2:8000/api"; // Gunakan IP emulator jika Android Emulator

  Future<Map<String, dynamic>> login(String id, String password) async {
    final url = Uri.parse('$baseUrl/login');
    print("🔵 Mengirim permintaan login ke $url");
    print("🟡 Data dikirim: ID=$id, Password=$password");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id, 'password': password}),
    );

    print("🟢 Status code: ${response.statusCode}");
    print("🟢 Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ Login berhasil, token: ${data['token']}");
      print("✅ Data user: ${data['user']}");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      await prefs.setString('role', data['user']['role']); // SIMPAN ROLE DI SINI


      return {'success': true, 'user': User.fromJson(data['user'])};
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Login gagal';
      print("❌ Login gagal: $error");
      return {'success': false, 'message': error};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    print("🔴 Logout: token dan user dihapus dari local storage");
  }

  Future<void> logoutFromServer() async {
    final token = await getToken();
    if (token == null) {
      print("⚠️ Tidak ada token untuk logout dari server");
      return;
    }

    final url = Uri.parse('$baseUrl/logout');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("🔴 Kirim logout ke server. Status: ${response.statusCode}");
    print("🔴 Response: ${response.body}");
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("🟣 Ambil token dari local storage: $token");
    return token;
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      print("🟣 Ambil user dari local storage: $userJson");
      return User.fromJson(jsonDecode(userJson));
    }
    print("🟣 Tidak ada user tersimpan");
    return null;
  }
}
