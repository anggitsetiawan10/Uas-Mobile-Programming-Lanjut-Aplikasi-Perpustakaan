import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constans/api.dart';
import '../models/profile_model.dart';

class ProfileService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Profile?> fetchProfile() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final profileData = data['profile'];

      if (profileData == null) {
        // 🔴 Data kosong dari API, return null
        return null;
      }

      return Profile.fromJson(profileData);
    } else {
      print('Gagal ambil profil: ${response.statusCode}');
      return null;
    }
  }


  Future<bool> updateProfile(Profile profile) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/profile'), // Ganti PUT ke POST
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      print('Profil berhasil diperbarui');
      return true;
    } else {
      print('Gagal update profil: ${response.statusCode}');
      print('Body: ${response.body}');
      return false;
    }
  }
}
