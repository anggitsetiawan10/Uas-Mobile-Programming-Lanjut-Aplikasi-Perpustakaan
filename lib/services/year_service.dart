import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constans/api.dart';

class YearService {
  Future<List<String>> fetchYears() async {
    final url = Uri.parse('$baseUrl/books/years');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map<String>((year) => year.toString()).toList();
    } else {
      throw Exception('Gagal mengambil daftar tahun');
    }
  }
}
