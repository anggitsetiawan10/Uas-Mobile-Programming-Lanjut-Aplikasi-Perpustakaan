// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constans/api.dart';
// import '../models/review.dart';
//
// class ReviewService {
//   Future<List<Review>> fetchUserReviews() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');
//
//     final response = await http.get(
//       Uri.parse('$baseUrl/reviews/user'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Accept': 'application/json',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       List<dynamic> data = jsonData['data'];
//       return data.map((item) => Review.fromJson(item)).toList();
//     } else {
//       throw Exception('Gagal mengambil review');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';
import '../constans/api.dart';

class ReviewService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Review>> fetchUserReviews() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('$baseUrl/reviews/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((item) => Review.fromJson(item)).toList();
    } else {
      throw Exception('❌ Gagal mengambil review');
    }
  }

  Future<bool> createReview(Review review) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(review.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateReview(int id, Review review) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/reviews/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(review.toJson()),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteReview(int id) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/reviews/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}

