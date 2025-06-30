import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constans/api.dart';
import '../models/book_model.dart';
import 'auth_service.dart';

class BookService {
  Future<List<Book>> fetchLatestBooks() async {
    try {
      final token = await AuthService().getToken();
      final url = Uri.parse('$baseUrl/books/latest');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data buku terbaru');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data buku: $e');
    }
  }

  Future<List<Book>> searchBooks({String? keyword, String? category, String? year}) async {
    try {
      final token = await AuthService().getToken();

      final queryParams = {
        if (keyword != null && keyword.isNotEmpty) 'q': keyword,
        if (category != null && category.isNotEmpty) 'genre': category,
        if (year != null && year.isNotEmpty) 'year': year,
      };

      final uri = Uri.parse('$baseUrl/books/search').replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      print('📡 Request URL: $uri');
      print('📥 Response Status: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mencari buku');
      }
    } catch (e) {
      print('❌ Kesalahan saat mencari buku: $e');
      throw Exception('Kesalahan saat mencari buku: $e');
    }
  }
  Future<List<Book>> fetchMostBorrowedBooks() async {
    final token = await AuthService().getToken();
    final url = Uri.parse('$baseUrl/books/most-borrowed');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil buku terbanyak dipinjam');
    }
  }

  Future<List<Book>> fetchTopRatedBooks() async {
    final token = await AuthService().getToken();
    final url = Uri.parse('$baseUrl/books/top-rated');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil buku rating tertinggi');
    }
  }

}
